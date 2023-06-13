//
//  PosterViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/13.
//

import UIKit
import RxSwift

class PosterViewController: UIViewController {
    static let storyBoardID: String = "PosterViewController"
    let disposeBag = DisposeBag()
    
    let posterURLObserver: AnyObserver<String>
    
    required init?(coder aDecoer: NSCoder) {
        let urlStrSubject = PublishSubject<String>()
        self.posterURLObserver = urlStrSubject.asObserver()
        
        super.init(coder: aDecoer)
        
        urlStrSubject
            .subscribe { str in
                guard let imageURL = URL(string: str) else {
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
            .disposed(by: disposeBag)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.posterImageView.backgroundColor = .black
        addTapGestureRecognizer()
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
}

extension PosterViewController: UIGestureRecognizerDelegate {
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchUpTap(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func touchUpTap(sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            self.dismiss(animated: true)
        }
    }
}
