//
//  ButtonTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/15.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    static let cellIdentifier = "ButtonTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func inputData(data: ViewMovieItems) {
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
