//
//  CollectionViewCollectionViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import UIKit

class BoxOfficeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "cellIdentifier"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
}
