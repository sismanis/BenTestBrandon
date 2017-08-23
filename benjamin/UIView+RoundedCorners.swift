//
//  UIView+RoundedCorners.swift
//  benjamin
//
//  Created by Brandon on 2017-08-23.
//  Copyright © 2017 Elevate Digital. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
