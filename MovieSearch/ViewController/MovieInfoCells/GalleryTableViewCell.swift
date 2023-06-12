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
        registerCVC()
        setFlowLayout()
    }

    var galleryData: ViewMovieItems?
    
    func inputData(data: ViewMovieItems) {
        galleryData = data
        collectionView.reloadData()
    }
    
    private func registerCVC() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let galleryCVC = UINib(nibName: "GalleryCollectionViewCell", bundle: nil)
        collectionView.register(galleryCVC, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellIdentifier)
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var collectionView: UICollectionView!
}

extension GalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryData?.posterURLs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellIdentifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell()
        }

        
        let imageURLStr = galleryData?.posterURLs[indexPath.item] ?? ""
        if imageURLStr == "" {
            return cell
        } else {
            guard let imageURL = URL(string: imageURLStr) else {
                cell.imageView.image = UIImage(named: "NoImageAvailable")
                return UICollectionViewCell()
            }
            URLSession.shared.dataTask(with: imageURL) { data, res, err in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        
        return cell
    }
    
    private func setFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width: 84, height: 110)
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
    }
}
