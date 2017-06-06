//
//  HCCardTools.swift
//  HCCardView
//
//  Created by UltraPower on 2017/5/24.
//  Copyright © 2017年 UltraPower. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func randomColor() -> UIColor{
        return UIColor(red: CGFloat(arc4random_uniform(256)) / CGFloat(255), green: CGFloat(arc4random_uniform(256)) / CGFloat(255), blue: CGFloat(arc4random_uniform(256)) / CGFloat(255), alpha: 1.0)
    }
}
