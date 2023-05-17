//
//  SavedMovielistViewController.swift
//  
//
//  Created by 윤지호 on 2023/05/17.
//

import UIKit
import RxSwift

class SavedMovielistViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel: SavedMovieListViewModelType
    
    init(viewModel: SavedMovieListViewModelType = SavedMovieListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = SavedMovieListViewModel()
        super.init(coder: aDecoder)
    }
    
    let movieList: [ViewMovieItems] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        registerXib()
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
    }
    
    private func registerXib() {
        let savedMovieTVC = UINib(nibName: "SavedMoviesTableViewCell", bundle: nil)
        tableView.register(savedMovieTVC, forCellReuseIdentifier: SavedMoviesTableViewCell.cellIdentifier)
    }
}
