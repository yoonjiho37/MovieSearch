//
//  InfomationTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import UIKit

class InfomationTableViewCell: UITableViewCell {
    static let cellIndentifier = "InfomationTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func inputData(data: ViewMovieItems) {
        self.titleLable.text = data.title
    }

    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var genreAndRatingLable: UILabel!
    @IBOutlet weak var runTimeLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var watchLaterButton: UIButton!
}
