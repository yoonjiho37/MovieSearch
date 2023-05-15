//
//  InfomationTableViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import UIKit

class InfomationTableViewCell: UITableViewCell {
    static let cellIndentifier = "InfomationTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func inputData(data: ViewMovieItems) {
        self.titleLable.text = data.title
        self.ratingImageView.image = data.rating.setUIImage()
        self.releaseDateLable.text = data.repRlsDate
        self.genreAndRuntimeLable.text = "\(data.genre) /  \(data.runtime)분"
        getImage(data: data)
        
        self.audiACCLabel.text = "\(data.audiAcc)명"
        self.rankLabel.text = "\(data.rank) / \(data.rankResult)"
    }
    
    private func getImage(data: ViewMovieItems) {
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

    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var releaseDateLable: UILabel!
    @IBOutlet weak var genreAndRuntimeLable: UILabel!
    
    @IBOutlet weak var audiACCLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
}

 
