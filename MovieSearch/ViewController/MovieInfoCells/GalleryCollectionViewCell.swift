//
//  CollectionViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/10.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    static var cellIdentifier = "GalleryCollectionCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
