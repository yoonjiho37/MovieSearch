//
//  GalleryTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    static let cellIndentifier = "GalleryTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var galleryCollectionView: UICollectionView!
}
