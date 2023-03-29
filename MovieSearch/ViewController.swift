//
//  ViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let viewModel: RankViewModelType
    let disposeBag = DisposeBag()
    
    init(viewModel: RankViewModelType = RankViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = RankViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    var boxOfficeList: [ViewList] = []
    
    
    func setupBinding() {
        //input
        viewModel.fetchList()
            
        //output
        viewModel.allList.subscribe(onNext: { data in
            self.boxOfficeList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellIdentifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        let item = boxOfficeList[indexPath.row]
        cell.name.text = item.movieNm
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boxOfficeList.count
    }
}
