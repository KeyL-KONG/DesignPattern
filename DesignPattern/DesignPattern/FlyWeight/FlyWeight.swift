//
//  FlyWeight.swift
//  DesignPattern
//
//  Created by keyl on 2023/6/4.
//

import UIKit

extension UIColor {
    public static var colorStore: [String: UIColor] = [:]
    
    public class func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpa: CGFloat) -> UIColor {
        let key = "\(red)\(green)\(blue)\(alpa)"
        if let color = colorStore[key] {
            return color
        }
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpa)
        colorStore[key] = color
        return color
    }
}

extension ViewController {
    func flyWeightExample() {
        let flyColor = UIColor.rgba(1, 0, 0, 1)
        let flyColor2 = UIColor.rgba(1, 0, 0, 1)
        print(flyColor == flyColor2)
    }
}
