//
//  SLNavigationBar.swift
//  SideMenu+Scroll
//
//  Created by Stan Liu on 1/30/16.
//  Copyright © 2016 Stan Liu. All rights reserved.
//

import UIKit

protocol SLNavigationBarDelegate {
    
    //func makeStatusBarStyle(style: Bool)
    func makeStatusBarStyle(style: Int)
    
}

let kTransparentNavigationBarAlpha: CGFloat = 0.0
let kDefaultNavigationBarAlpha: CGFloat = 1.0

let kDefaultColorLayerOpacity: Float = 0.5
let kSpaceToCoverStatusBars: Float = 20.0

enum StatusStyle: Int {
    
    case Light = 0
    case Dark = 1
}

@IBDesignable
class SLNavigationBar: UINavigationBar {
    
    var slNavigationDelegate: SLNavigationBarDelegate?
    
    var colorLayer: CALayer!
    var style: StatusStyle = .Light
    
    @IBInspectable var status: Int {
    
        get {
            return style.rawValue
        }
        
        set (styleIndex) {
            style = StatusStyle(rawValue: styleIndex) ?? . Light
            slNavigationDelegate?.makeStatusBarStyle(style.rawValue)
            print(style.rawValue)
        }
        /*
        didSet {
            
            switch status {
            case .Light:
                slNavigationDelegate?.makeStatusBarStyle(0)
            case .Dark:
                slNavigationDelegate?.makeStatusBarStyle(1)
            }
            /*
            slNavigationDelegate?.makeStatusBarStyle(status)
            */
            print("status bar: \(status)")
        }*/
    }
    
    @IBInspectable var transparentBar: Bool = false {
        
        didSet {
            if transparentBar == true {
                // http://sketchytech.blogspot.tw/2014/08/unsafe-pointers-in-swift-first-look.html
                // .alloc(1) allocate memory for one object
                let red = UnsafeMutablePointer<CGFloat>.alloc(1)
                let green = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blue = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alpha = UnsafeMutablePointer<CGFloat>.alloc(1)
                barTintColor?.getRed(red, green: green, blue: blue, alpha: alpha)
                let afterRed = red.memory
                let afterGreen = green.memory
                let afterBlue = blue.memory
                //let afterAlpha = alpha.memory
                let afterBarTintColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: kTransparentNavigationBarAlpha)
                
                let image = imageWithColor(afterBarTintColor)
                
                setBackgroundImage(image, forBarMetrics: .Default)
                shadowImage = UIImage()
                //barStyle = .Default
            } else {
                let red = UnsafeMutablePointer<CGFloat>.alloc(1)
                let green = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blue = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alpha = UnsafeMutablePointer<CGFloat>.alloc(1)
                barTintColor?.getRed(red, green: green, blue: blue, alpha: alpha)
                let afterRed = red.memory
                let afterGreen = green.memory
                let afterBlue = blue.memory
                //let afterAlpha = alpha.memory
                let afterBarTintColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: kDefaultNavigationBarAlpha)
                let image = imageWithColor(afterBarTintColor)
                setBackgroundImage(image, forBarMetrics: .Default)
                shadowImage = UIImage()
                //barStyle = .Default
            }
        }
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /*
    override var barTintColor: UIColor? {
        
        didSet {
            if #available(iOS 7.0.3, *) {
                
                // http://sketchytech.blogspot.tw/2014/08/unsafe-pointers-in-swift-first-look.html
                // .alloc(1) allocate memory for one object
                let red = UnsafeMutablePointer<CGFloat>.alloc(1)
                let green = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blue = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alpha = UnsafeMutablePointer<CGFloat>.alloc(1)
                barTintColor?.getRed(red, green: green, blue: blue, alpha: alpha)
                let afterRed = red.memory
                let afterGreen = green.memory
                let afterBlue = blue.memory
                let afterAlpha = alpha.memory

                // if version greater than 7.0.3
                if transparentBar != nil {
                    
                    let afterTintColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: 0.70)
                    super.barTintColor = afterTintColor
                } else if transparentBar == true {
                    let afterTintColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: 0)
                    super.barTintColor = afterTintColor
                } else {
                    let afterTintColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: 1.0)
                    super.barTintColor = afterTintColor
                }
                print("red:\(red),green:\(green),blue:\(blue),alpha:\(alpha)")
                red.destroy() // first destroy object to return to deinitialized state
                red.dealloc(1) // deallocate the memory so that the object can go out of memory
                green.destroy()
                green.dealloc(1)
                blue.destroy()
                blue.dealloc(1)
                alpha.destroy()
                alpha.dealloc(1)
                
            } else if #available(iOS 7.0, *) {
                //  iOS 7.0 benefits from the extra color layer
                if colorLayer == nil {
                    colorLayer = CALayer()
                    colorLayer.opacity = kDefaultColorLayerOpacity
                    layer.addSublayer(colorLayer)
                }
                self.colorLayer.backgroundColor = barTintColor?.CGColor
            }
            
        }
    }*/
}
