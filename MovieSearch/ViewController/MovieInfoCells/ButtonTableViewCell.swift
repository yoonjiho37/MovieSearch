//
//  ButtonTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/15.
//

import UIKit
import RxSwift

class ButtonTableViewCell: UITableViewCell {
    static let cellIdentifier = "ButtonTableViewCell"
    
    let disposeBag = DisposeBag()
    let cellDataObs: AnyObserver<ViewMovieItems>
    
    required init?(coder aDecoder: NSCoder) {
        let cellDataSubject = PublishSubject<ViewMovieItems>()
        self.cellDataObs = cellDataSubject.asObserver()
        
        super.init(coder: aDecoder)
        
        cellDataSubject
            .subscribe { [weak self] data in
                self?.inputData(data: data)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func inputData(data: ViewMovieItems) {
        if data.likeBoolean {
            print("do1")
            likeButton.setTitle("좋아요 취소", for: .normal)
            likeButton.tintColor = .red
        } else {
            print("do1-2")
            likeButton.setTitle("좋아요 추가", for: .normal)
            likeButton.tintColor = .systemBlue
        }
        
        if data.watchLaterBoolean {
            print("do2")
            watchLaterButton.setTitle("나중에 볼 영화 취소", for: .normal)
            watchLaterButton.tintColor = .red
        } else {
            print("do2-2")
            watchLaterButton.setTitle("나중에 볼 영화 추가", for: .normal)
            watchLaterButton.tintColor = .systemBlue
        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var watchLaterButton: UIButton!
}
