//
//  SavedMoviesTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/17.
//

import UIKit

class SavedMoviesTableViewCell: UITableViewCell {
    static let cellIdentifier = "SavedMoviesTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func inputData(data: ViewMovieItems) {
        
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
}
