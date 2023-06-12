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
        setLayoutProperties()
    }

    func inputData(data: ViewMovieItems) {
        self.titleLabel.text = data.title
        self.ratingImageView.image = data.rating.setUIImage()
        self.releaseDateLabel.text = data.repRlsDate
        self.genreAndRuntimeLabel.text = "\(data.genre) /  \(data.runtime)분"
        getImage(data: data)
        self.companyLabel.text = data.company
        
        self.audiACCLabel.text = "\(data.audiAcc)명"
        self.rankLabel.text = "\(data.rank) / \(data.rankResult)"
    }
    
    private func getImage(data: ViewMovieItems) {
        let imageURLStr = data.posterURLs[0]
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
    
    private func setLayoutProperties() {
        self.backgroundColor = UIColor.clear
    }
    
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreAndRuntimeLabel: UILabel!
    @IBOutlet weak var companyLabel:UILabel!
    
    @IBOutlet weak var audiACCLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
}

 
