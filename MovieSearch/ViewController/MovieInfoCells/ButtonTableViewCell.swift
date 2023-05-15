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
            likeButton.titleLabel?.text = "좋아요 취소"
            likeButton.tintColor = .red
        } else {
            likeButton.titleLabel?.text = "좋아요"
            likeButton.tintColor = .systemBlue
        }
        
        if data.watchLaterBoolean {
            watchLaterButton.titleLabel?.text = "나중에 볼 영화 취소"
            watchLaterButton.tintColor = .red
        } else {
            watchLaterButton.titleLabel?.text = "나중에 볼 영화 추가"
            watchLaterButton.tintColor = .systemBlue
        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var watchLaterButton: UIButton!
}
