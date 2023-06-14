//
//  extnsion.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/12.
//

import Foundation
import UIKit


@IBDesignable
class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradoentColor: UIColor? {
        didSet {
            setGradient(topGradoentColor: topGradoentColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradoentColor: topGradoentColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    
    private func setGradient(topGradoentColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradoentColor = topGradoentColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradoentColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.startPoint = CGPoint(x: 0 , y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.cornerRadius = 10
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    
}



