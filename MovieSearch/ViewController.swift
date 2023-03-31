//
//  ViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let viewModel: RankViewModelType
    let disposeBag = DisposeBag()
    
    init(viewModel: RankViewModelType = RankViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = RankViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    var boxOfficeList: [ViewList] = []
    var nowPage: Int = 0
    var currentIndex: CGFloat = 0
    
    var isOneStepPaging = true
    
    func setupBinding() {
        //input
        viewModel.fetchList()
            
        //output
        viewModel.allList.subscribe(onNext: { data in
            self.boxOfficeList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    func setupUI() {
        setFlowLayout()
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rankAndNameLabel: UILabel!
    @IBOutlet weak var salesShare: UILabel!
    @IBOutlet weak var infoButton: UIButton!
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellIdentifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        let item = boxOfficeList[indexPath.row]
        cell.rankLabel.text = item.rank
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxOfficeList.count
    }
    
    func setFlowLayout() {
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
        let index: Int
            
        // 스크롤 방향 체크
        // item 절반 사이즈 만큼 스크롤로 판단하여 올림, 내림 처리
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        nowPage = index
        // 위 코드를 통해 페이징 될 좌표 값을 targetContentOffset에 대입
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
}
