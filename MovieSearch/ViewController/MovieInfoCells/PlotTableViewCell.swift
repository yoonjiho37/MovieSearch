//
//  DescriptionTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import UIKit

class PlotTableViewCell: UITableViewCell {
    static let cellIndentifier = "PlotTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func inputData(data: ViewMovieItems) {
        self.plotLable.text = data.plot
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var plotLable: UILabel!
}
