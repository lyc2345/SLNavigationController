//
//  SLNavigationBar.swift
//  SideMenu+Scroll
//
//  Created by Stan Liu on 1/30/16.
//  Copyright © 2016 Stan Liu. All rights reserved.
//

import UIKit

protocol SLNavigationBarDelegate {
    
    func makeStatusBar(option: Bool)

}

let kDefaultNavigationBarAlpha: Float = 0.70

let kDefaultColorLayerOpacity: Float = 0.5
let kSpaceToCoverStatusBars: Float = 20.0

class SLNavigationBar: UINavigationBar {
    
    var slNavigationDelegate: SLNavigationBarDelegate?
    
    var overrideOpacity: Bool!
    
    var colorLayer: CALayer!
    
    @IBInspectable var sStatusBarStyle: Bool = false {
        
        didSet {
            if sStatusBarStyle == true {
                slNavigationDelegate?.makeStatusBar(true)
            } else {
                slNavigationDelegate?.makeStatusBar(false)
            }
        }
    }
    
    @IBInspectable var barOpacity: Bool? {
        
        didSet {
            if barOpacity == nil {
                barOpacity = false
            }
        }
    }

    @IBInspectable var barOpacityColor: UIColor? {
        
        didSet {
            if barOpacity == false {
                
                
                let red = UnsafeMutablePointer<CGFloat>.alloc(1)
                let green = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blue = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alpha = UnsafeMutablePointer<CGFloat>.alloc(1)
                barOpacityColor?.getRed(red, green: green, blue: blue, alpha: alpha)
                
                // http://stackoverflow.com/questions/33525608/how-to-access-unsafemutablepointer-struct-member
                let afterRed = red.memory
                let afterGreen = green.memory
                let afterBlue = blue.memory
                
                let alphaedColor = UIColor(red: afterRed, green: afterGreen, blue: afterBlue, alpha: 0.0)
                red.destroy() // first destroy object to return to deinitialized state
                red.dealloc(1) // deallocate the memory so that the object can go out of memory
                green.destroy()
                green.dealloc(1)
                blue.destroy()
                blue.dealloc(1)
                alpha.destroy()
                alpha.dealloc(1)
                setBackgroundImage(imageWithColor(alphaedColor), forBarMetrics: UIBarMetrics.Default)
                self.barStyle = .Default
                self.shadowImage = UIImage()
                self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                self.tintColor = UIColor.whiteColor()
                self.translucent = true
                
                
            } else {
                barTintColor = barOpacityColor!
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
    
    override var barTintColor: UIColor? {
        
        didSet {
            
            // if version greater than 7.0.3
            if overrideOpacity != nil {
                // http://sketchytech.blogspot.tw/2014/08/unsafe-pointers-in-swift-first-look.html
                // .alloc(1) allocate memory for one object
                let red = UnsafeMutablePointer<CGFloat>.alloc(1)
                let green = UnsafeMutablePointer<CGFloat>.alloc(1)
                let blue = UnsafeMutablePointer<CGFloat>.alloc(1)
                let alpha = UnsafeMutablePointer<CGFloat>.alloc(1)
                barTintColor?.getRed(red, green: green, blue: blue, alpha: alpha)
                print("red:\(red),green:\(green),blue:\(blue),alpha:\(alpha)")
                red.destroy() // first destroy object to return to deinitialized state
                red.dealloc(1) // deallocate the memory so that the object can go out of memory
                green.destroy()
                green.dealloc(1)
                blue.destroy()
                blue.dealloc(1)
                alpha.destroy()
                alpha.dealloc(1)
            }
            //  iOS 7.0 benefits from the extra color layer
            if colorLayer == nil {
                colorLayer = CALayer()
                colorLayer.opacity = kDefaultColorLayerOpacity
                layer.addSublayer(colorLayer)
            }
            
            super.barTintColor = self.barTintColor!
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let yPoint = 0 - Int(kSpaceToCoverStatusBars)
        
        let boundHeight = Float(CGRectGetHeight(self.bounds))
        
        if colorLayer != nil {
            colorLayer.frame = CGRectMake(0, CGFloat(yPoint), CGRectGetWidth(self.bounds), CGFloat(boundHeight + kSpaceToCoverStatusBars))
            layer.insertSublayer(colorLayer, atIndex: 1)
        }
    }
    
    func displayColorLayer(display: Bool) {
        colorLayer.hidden = !display
    }
    
}
