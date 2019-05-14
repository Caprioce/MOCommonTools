//
//  Color+common.swift
//  cooperator
//
//  Created by ccy on 2017/12/21.
//  Copyright © 2017年 ChiYue. All rights reserved.
//

import Foundation

extension UIColor {

    public class func color(hexString: String, alpha: CGFloat = 1.0 ) -> UIColor {
        var colorStr = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if colorStr.length < 6 {
            return UIColor.clear
        }
        if colorStr.hasPrefix("0X") {
            colorStr = colorStr.substring(from: 2) as NSString
        }
        if colorStr.hasPrefix("#") {
            colorStr = colorStr.substring(from: 1) as NSString
        }
        if colorStr.length != 6 {
            return UIColor.clear
        }
        var range      = NSRange.init(location: 0, length: 2)
        let redStr     = colorStr.substring(with: range)
        range.location = 2
        let greenStr   = colorStr.substring(with: range)
        range.location = 4
        let blueStr    = colorStr.substring(with: range)
        var r: UInt32  = 0x0
        var g: UInt32  = 0x0
        var b: UInt32  = 0x0
        Scanner.init(string: redStr).scanHexInt32(&r)
        Scanner.init(string: greenStr).scanHexInt32(&g)
        Scanner.init(string: blueStr).scanHexInt32(&b)
        return UIColor.init(red: (CGFloat(r) / 255.0), green: (CGFloat(g) / 255.0), blue: (CGFloat(b) / 255.0), alpha: alpha)
    }

}

extension UIView {

    func drawColor() {
        let gradient             = CAGradientLayer.init()
        gradient.frame           = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradient.colors          = [UIColor.color(hexString: "9fdc9b").cgColor, UIColor.color(hexString: "26a89f").cgColor]
        gradient.startPoint      = CGPoint.init(x: 0, y: 0.5);
        gradient.endPoint        = CGPoint.init(x: 1, y: 0.5);
        layer.insertSublayer(gradient, at: 0)
    }

}

extension Double {

    var suitWidth: CGFloat {
        return CGFloat(self/375)*kScreenWidth
    }

    var suitHeight: CGFloat {
        return CGFloat(self/668)*kScreenHeight
    }

}
