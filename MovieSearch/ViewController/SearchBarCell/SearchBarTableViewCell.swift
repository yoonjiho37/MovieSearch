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
        setLayoutPropertys()
    }

    func inputData(data: String) {
        titleLable.text = data
    }
    
    private func setLayoutPropertys() {
        self.backgroundColor = UIColor.clear
        titleLable.textColor = .white
    }
    
    @IBOutlet weak var titleLable: UILabel!
}
