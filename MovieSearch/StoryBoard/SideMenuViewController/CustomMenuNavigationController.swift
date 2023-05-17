//
//  SideMenuNavigationController.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/17.
//

import Foundation
import SideMenu

class CustomMenuNavigationController: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.statusBarEndAlpha = 0
        self.presentationStyle = .menuSlideIn
        self.leftSide = true
        self.menuWidth = self.view.frame.width * 0.5
        self.presentDuration = 1
        self.dismissDuration = 1
    }
    
}
