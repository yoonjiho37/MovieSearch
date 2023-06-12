//
//  SearchBarViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/08.
//

import UIKit
import RxSwift

class SearchBarViewController: UIViewController {
    static let storyBoardId: String = "SearchBarViewController"
    
    let disposeBag = DisposeBag()
    let viewModel: SearchBarViewModelType
    
    init(viewModel: SearchBarViewModelType = SearchBarViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = SearchBarViewModel()
        super.init(coder: aDecoder)
    }
    
    var searchResults: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTablaView()
        setSearchBar()
        setupBinding()
        setViewColor()
    }
    
    func setupBinding() {
        
        viewModel.getsearchResult()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] list in
                self?.searchResults = list
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.getErrorMessage()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] err in
                self?.searchResults = ["검색결과가 없습니다."]
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.getInfoItem()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] item in
                guard let infoItem = item.element else { return }
                guard let infoVC = self?.storyboard?.instantiateViewController(identifier: "MovieInfoViewController") as? MovieInfoViewController else { return }
                let infoViewModel = MovieInfoViewModel([infoItem])
                infoVC.viewModel = infoViewModel
                
                self?.navigationController?.pushViewController(infoVC, animated: true)

            }
            .disposed(by: disposeBag)
    }
    private func setViewColor() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.cyan.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundColor = UIColor.clear
    }
    
    var tableView: UITableView!
}

extension SearchBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableViewCell.cellIdentifier, for: indexPath) as? SearchBarTableViewCell else { return UITableViewCell() }
        
        cell.inputData(data: searchResults[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getSelectEvent(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchBarViewController {
    func setTablaView() {
        tableView = UITableView()
        self.view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        
        regiserXib()
        setTableViewLayout()
    }
    
    func regiserXib() {
        let SearchBarTVC = UINib(nibName: "SearchBarTableViewCell", bundle: nil)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchBarTableViewCell.cellIdentifier)
        self.tableView.register(SearchBarTVC, forCellReuseIdentifier: SearchBarTableViewCell.cellIdentifier)
    }
    
    func setTableViewLayout() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView!,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .top,
                                                    multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView!,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .bottom,
                                                    multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView!,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .leading,
                                                    multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView!,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .trailing,
                                                    multiplier: 1.0, constant: 0.0))
    }

}


extension SearchBarViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputedText = searchController.searchBar.text else { return }
        viewModel.getInputedText(text: inputedText)
    }
    
    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "찾고싶은 영화를 입력해 주세요"
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
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

