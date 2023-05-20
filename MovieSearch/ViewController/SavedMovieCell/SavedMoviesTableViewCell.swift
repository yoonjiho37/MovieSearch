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
        titleLabel.text = data.title
        setImage(data: data)
    }
    
    private func setImage(data: ViewMovieItems) {
        let imageURLStr = data.posterURL[0]
        guard let imageURL = URL(string: imageURLStr) else {
            self.posterImageView.image = UIImage(named: "NoImageAvailable")
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, res, err in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
}
