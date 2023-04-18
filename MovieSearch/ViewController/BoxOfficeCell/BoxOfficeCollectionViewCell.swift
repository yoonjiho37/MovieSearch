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
    let getDataObserver : AnyObserver<ViewMovieList>
    
    required init?(coder aDecoder: NSCoder) {
        let cellDataSubject = PublishSubject<ViewMovieList>()
        getDataObserver = cellDataSubject.asObserver()
        
        super.init(coder: aDecoder)

        cellDataSubject.observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                guard let imageURL = URL(string: item.posterURL[0]) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                self?.posterImageView.image = UIImage(data: imageData)
            }
            .disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    //MARK: InterfaceBuilder Links
    @IBOutlet weak var posterImageView: UIImageView!

}
