//
//  SLNavigationController.swift
//  SideMenu+Scroll
//
//  Created by Stan Liu on 1/30/16.
//  Copyright © 2016 Stan Liu. All rights reserved.
//

import UIKit


class SLNavigationController: UINavigationController {
    
    var isOpacity: Bool = false
    
    init() {
        
        super.init(navigationBarClass: SLNavigationBar.self, toolbarClass: nil)
        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.overrideOpacity = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.overrideOpacity = false
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.overrideOpacity = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        switch isOpacity.hashValue {
        case 0:
            return .LightContent
        case 1:
            return .Default
        default:
            return .Default
        }
    }
}

extension SLNavigationController: SLNavigationBarDelegate {
    
    func makeStatusBar(option: Bool) {
        
        isOpacity = option
    }
    
}
