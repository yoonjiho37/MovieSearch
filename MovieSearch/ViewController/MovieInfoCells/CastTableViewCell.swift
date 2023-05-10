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
    }

    func inputData(data: ViewMovieItems) {
        let actorNames = data.actors.actor.map { $0.actorNm }
        self.diractorLabel.text = data.directorNm
        self.actorLabel.text = actorNames.joined(separator: ", ")
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var diractorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
}
