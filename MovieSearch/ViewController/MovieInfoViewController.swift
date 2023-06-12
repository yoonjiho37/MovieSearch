//
//  MovieInfoViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/18.
//

import UIKit
import RxSwift

class MovieInfoViewController: UIViewController {
    static let identifer = "MovieInfoSegueIdentifier"

    var viewModel: MovieInfoViewModelType
    var disposeBag = DisposeBag()
    
    init(viewmodel: MovieInfoViewModelType = MovieInfoViewModel()) {
        self.viewModel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        viewModel = MovieInfoViewModel()
        super.init(coder: aDecoder)
    }
    
    var movieInfo: ViewMovieItems?
    var cellCaseList: [CellCase] = []
    var dataSource = [CellCase]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        registerXib()
        setViewColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAppearEvent()
    }
    
    
    private func setupBinding() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        viewModel.getMovieInfo()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { info in
                self.movieInfo = info
                guard let movieInfo = self.movieInfo else { return }
                
                let info1 = CellCase.info(movieInfo)
                let info2 = CellCase.buttons(movieInfo)
                let info3 = CellCase.gallery(movieInfo)
                let info4 = CellCase.plot(movieInfo)
                let info5 = CellCase.cast(movieInfo)
                self.dataSource = [info1, info2, info3, info4, info5]
                
                self.tableView.reloadData()
                
            }
            .disposed(by: disposeBag)
        
        viewModel.getUpdateResult()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { info in                
                self.movieInfo = info.element
                guard let movieInfo = self.movieInfo else { return }
                
                let info2 = CellCase.buttons(movieInfo)

                self.dataSource[1] = info2
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }
            .disposed(by: disposeBag)
        
        viewModel.getErrorMassage()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { err in self.showErrorAlert(message: err)})
            .disposed(by: disposeBag)
    }
    
    
    //MARK: InterfaceBuilder Link
    @IBOutlet weak var tableView: UITableView!
    @IBAction func touchWB(_ sender: UIButton) {
        viewModel.getUpdateEvent(type: .watchLater)
    }
    @IBAction func touchLB(_ sender: UIButton) {
        viewModel.getUpdateEvent(type: .like)
    }
}

extension MovieInfoViewController {
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
    
    private func setViewColor() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.cyan.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundColor = UIColor.clear
    }
}

extension MovieInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource[section] {
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellCase = dataSource[indexPath.section]
        guard let movieInfo = movieInfo else {  return UITableViewCell() }
        switch cellCase {
        case .info(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfomationTableViewCell.cellIndentifier, for: indexPath) as? InfomationTableViewCell else { return UITableViewCell() }
            cell.inputData(data: movieInfo)
            return cell
        case .buttons(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.cellIdentifier, for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
            cell.inputData(data: movieInfo)
            return cell
        case .gallery(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GalleryTableViewCell.cellIndentifier, for: indexPath) as? GalleryTableViewCell else { return UITableViewCell() }
            cell.inputData(data: movieInfo)
            return cell
        case .plot(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlotTableViewCell.cellIndentifier, for: indexPath) as? PlotTableViewCell else { return UITableViewCell()}
            cell.inputData(data: movieInfo)
            return cell
        case .cast(_):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.cellIndentifier, for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            cell.inputData(data: movieInfo)
            return cell
        }
    }
}


extension MovieInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    private func registerXib() {
        let infoTVC = UINib(nibName: "InfomationTableViewCell", bundle: nil)
        tableView.register(infoTVC, forCellReuseIdentifier: InfomationTableViewCell.cellIndentifier)
        let buttonTVC = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        tableView.register(buttonTVC, forCellReuseIdentifier: ButtonTableViewCell.cellIdentifier)
        let galleryTVC = UINib(nibName: "GalleryTableViewCell", bundle: nil)
        tableView.register(galleryTVC, forCellReuseIdentifier: GalleryTableViewCell.cellIndentifier)
        let plotTVC = UINib(nibName: "PlotTableViewCell", bundle: nil)
        tableView.register(plotTVC, forCellReuseIdentifier: PlotTableViewCell.cellIndentifier)
        let castTVC = UINib(nibName: "CastTableViewCell", bundle: nil)
        tableView.register(castTVC, forCellReuseIdentifier: CastTableViewCell.cellIndentifier)
    }
}
