//
//  SideMenuViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/17.
//

import UIKit

class SideMenuViewController: UIViewController {
    static let storyBoardID = "SideMenuViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifer = segue.identifier ?? ""
        if identifer == SavedMovielistViewController.identifier {
            guard let typeSender = sender as? ListType else { return }
            guard let movieListVC = segue.destination as? SavedMovielistViewController else { return }
            
            movieListVC.listType = typeSender
            
        }
    }
    
    
    @IBAction func showMainButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func showLikedMoviesButton(sender: Any?) {
        self.performSegue(withIdentifier: SavedMovielistViewController.identifier, sender: ListType.liked)
        
    }
    @IBAction func showMoviesToWatchLaterButton(_ sender: Any) {
        self.performSegue(withIdentifier: SavedMovielistViewController.identifier, sender: ListType.watchLater)
    }

}
