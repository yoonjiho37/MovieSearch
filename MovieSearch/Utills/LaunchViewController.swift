//
//  LaunchViewController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/14.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
    }
    
    private func setViewColor() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.cyan.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
