//
//  SearchBarTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/08.
//

import UIKit

class SearchBarTableViewCell: UITableViewCell {
    static let cellIdentifier: String = "SearchBarTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func inputData(data: String) {
        titleLable.text = data
    }
    
    @IBOutlet weak var titleLable: UILabel!
}
