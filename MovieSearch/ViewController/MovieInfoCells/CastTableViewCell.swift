//
//  CastTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import UIKit

class CastTableViewCell: UITableViewCell {
    static let cellIndentifier = "CastTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func inputData(data: ViewMovieItems) {
        self.diractorLabel.text = data.directorNm
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var diractorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
}
