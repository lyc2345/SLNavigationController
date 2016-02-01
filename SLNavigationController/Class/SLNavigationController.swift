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
    var barStyle: Int = 0
    
    init() {
        
        super.init(navigationBarClass: SLNavigationBar.self, toolbarClass: nil)
        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.transparentBar = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.transparentBar = false
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let navigationBar = self.navigationBar as! SLNavigationBar
        navigationBar.slNavigationDelegate = self
        navigationBar.transparentBar = false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        /*
        switch isOpacity.hashValue {
        case 0:
            return .Default
        case 1:
            return .LightContent
        default:
            return .Default
        }*/
        switch barStyle {
        case 0:
            return .Default
        case 1:
            return .LightContent
        default:
            return .Default
        }
    }
}

extension SLNavigationController: SLNavigationBarDelegate {
    
    func makeStatusBarStyle(style: Int) {
        barStyle = style
    }
}
