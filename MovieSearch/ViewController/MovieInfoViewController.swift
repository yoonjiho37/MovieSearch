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

    let disposeBag = DisposeBag()
    var viewModel: MovieInfoViewModelType
    
    init(viewmodel: MovieInfoViewModelType = MovieInfoViewModel()) {
        self.viewModel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = MovieInfoViewModel()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
