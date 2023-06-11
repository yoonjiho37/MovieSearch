//
//  ViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: BoxOfficeViewModelType
    
    init(viewModel: BoxOfficeViewModelType = BoxOfficeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = BoxOfficeViewModel()
        super.init(coder: aDecoder)
    }
    
    var boxOfficeList: [ViewMovieItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifer = segue.identifier ?? ""
        
        if identifer == MovieInfoViewController.identifer {
            guard let seletedMovie = sender as? [ViewMovieItems] else { return }
            guard let movieInfoVC = segue.destination as? MovieInfoViewController else { return }
            let infoViewModel = MovieInfoViewModel(seletedMovie)
            movieInfoVC.viewModel = infoViewModel
        }
    }

    private func setupBinding() {
      
        //input
        viewModel.fetchList(type: .daily)

        //output
        viewModel.getAllList()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                
                self.boxOfficeList = data
                self.viewModel.getNowPage(page: 0)
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.getPageData()
            .observe(on: MainScheduler.instance)
            .subscribe { item in
                self.setupPageDatas(item: item[0])
            }
            .disposed(by: disposeBag)
        
        viewModel.getInfoView()
            .subscribe { [weak self] item in
                self?.performSegue(withIdentifier: MovieInfoViewController.identifer, sender: item.element)
            }
            .disposed(by: disposeBag)

        viewModel.getErrorMassage()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] err in
                self?.showErrorAlert(message: err)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        showMenuOrAlret()
        setFlowLayout()
    }
    
    private func setupPageDatas(item: ViewMovieItems) {
        rankAndNameLabel.text = "\(item.rank)위 / \(item.title)"
        salesShare.text = "\(item.rating)"
    }

    //MARK: - InterfaceBuilder Links
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rankAndNameLabel: UILabel!
    @IBOutlet weak var salesShare: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet var showMenuButton: UIBarButtonItem!
    @IBAction func showSearchVC() {
        guard let searchVC = storyboard?.instantiateViewController(identifier: SearchBarViewController.storyBoardId) else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @IBAction func touchUpInfoButton(sender: Any?) {
        viewModel.getTapEvent()
    }
    
}



extension BoxOfficeViewController {
    private func showMenuOrAlret() {
        print("do")
        if #available(iOS 14.0, *) {
            showMenuButton.menu = getUIMenu()
        } else {
            showMenuButton.target = self
            showMenuButton.action = #selector(getActionAlert)
        }
    }
    
    private func getUIMenu() -> UIMenu {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "일별 박스오피스",handler: { _ in
                    self.viewModel.fetchList(type: .daily)
                    self.showMenuButton.title = "일별"
                }),
                UIAction(title: "주간 박스오피스",handler: { _ in
                    self.viewModel.fetchList(type: .weekly)
                    self.showMenuButton.title = "주간"

                }),
                UIAction(title: "주말 박스오피스",handler: { _ in
                    self.viewModel.fetchList(type: .weekEnd)
                    self.showMenuButton.title = "주말"
                })
            ]
        }
        var menu: UIMenu {
            return UIMenu(title: "", children: menuItems)
        }
        return menu
    }
    
    @objc func getActionAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let boxOfficeType: [BoxOfficeType] = [.daily, .weekly, .weekEnd]
        
        for type in boxOfficeType {
            alert.addAction(UIAlertAction(title: type.rawValue, style: .default, handler: { _ in
                self.viewModel.fetchList(type: type)
                self.showMenuButton.title = type.rawValue.components(separatedBy: " ")[0]
            }))
        }
        self.present(alert, animated: true)
    }
    
    private func showErrorAlert(message: NSError) {
        let message = message.domain
        let alert = UIAlertController(title: "오류 발생", message: "\(message)", preferredStyle: .alert)
        let appDownAction = UIAlertAction(title: "앱 종료", style: .cancel, handler: { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        })
        alert.addAction(appDownAction)
        
        self.present(alert, animated: true)
    }
}

extension BoxOfficeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeCollectionViewCell.cellIdentifier, for: indexPath) as? BoxOfficeCollectionViewCell else { return UICollectionViewCell() }
        let item = boxOfficeList[indexPath.row]        
        cell.getDataObserver.onNext(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxOfficeList.count
    }
    
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let screenWidthSize = UIScreen.main.bounds.width
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: screenWidthSize - 120, height: screenWidthSize - 20)
        flowLayout.minimumLineSpacing = 40
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        collectionView.collectionViewLayout = flowLayout
        collectionView.decelerationRate = .fast
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        // CollectionView Item Size
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        // 이동한 x좌표 값과 item의 크기를 비교 후 페이징 값 설정
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        var index: Int
            
        // 스크롤 방향 체크
        // item 절반 사이즈 만큼 스크롤로 판단하여 올림, 내림 처리
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
      
        if index < 0 {
            index = 0
        } else if index > 9 {
            index = 9
        }
        viewModel.getNowPage(page: index)
        // 위 코드를 통해 페이징 될 좌표 값을 targetContentOffset에 대입
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
    
}
