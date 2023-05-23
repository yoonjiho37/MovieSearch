//
//  SavedMovielistViewController.swift
//  
//
//  Created by 윤지호 on 2023/05/17.
//

import UIKit
import RxSwift

class SavedMovielistViewController: UIViewController {
    static let identifier = "SavedMovielistSegueIdentifier"
    
    let disposeBag = DisposeBag()
    var viewModel: SavedMovieListViewModelType
    var listType: ListType = .liked
    
    init(viewModel: SavedMovieListViewModelType = SavedMovieListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = SavedMovieListViewModel()
        super.init(coder: aDecoder)
    }
    
    var movieList: [ViewMovieItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAppearState(type: listType)
    }
    
    private func setupBinding() {
        
        viewModel.getMovieList()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { list in
                self.movieList = list
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
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
    


    //MARK: Interface Link
    @IBOutlet weak var tableView: UITableView!
}

extension SavedMovielistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedMoviesTableViewCell.cellIdentifier, for: indexPath) as? SavedMoviesTableViewCell else { return UITableViewCell() }
        let movie = movieList[indexPath.row]
        cell.inputData(data: movie)
        
        return cell
    }
    
}
extension SavedMovielistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let seletedItem = [movieList[indexPath.row]]
        self.performSegue(withIdentifier: MovieInfoViewController.identifer, sender: seletedItem)
    }
    
    
    
    private func registerXib() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let savedMovieTVC = UINib(nibName: "SavedMoviesTableViewCell", bundle: nil)
        tableView.register(savedMovieTVC, forCellReuseIdentifier: SavedMoviesTableViewCell.cellIdentifier)
    }
}
