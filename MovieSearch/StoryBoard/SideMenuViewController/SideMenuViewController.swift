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
    
    @IBAction func showMainButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func showLikedMoviesButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func showMoviesToWatchLaterButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
