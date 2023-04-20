//
//  CollectionViewCollectionViewCell.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import UIKit
import RxSwift

class BoxOfficeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "BoxOfficeCellIdentifier"
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    let getDataObserver : AnyObserver<ViewMovieItems>
    
    required init?(coder aDecoder: NSCoder) {
        let cellDataSubject = PublishSubject<ViewMovieItems>()
        getDataObserver = cellDataSubject.asObserver()
        
        super.init(coder: aDecoder)

        cellDataSubject
            .subscribe { [weak self] item in
                guard let imageURL = URL(string: item.posterURL[0]) else {
                    self?.posterImageView.image = UIImage(named: "NoImageAvailable")
                    return
                }
                URLSession.shared.dataTask(with: imageURL) { data, res, err in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self?.posterImageView.image = UIImage(data: data)
                    }
                }.resume()
            }
            .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        posterImageView.image = nil
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var posterImageView: UIImageView!

}
