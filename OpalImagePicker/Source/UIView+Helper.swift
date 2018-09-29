//
//  UIView+Helper.swift
//  OpalImagePicker
//
//  Created by Kristos Katsanevas on 9/30/17.
//  Copyright © 2017 Opal Orange LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func constraintsToFill(otherView: Any) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: otherView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: otherView, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: otherView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: otherView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ]
    }
    
    func constraintsToCenter(otherView: Any) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: otherView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: otherView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ]
    }
    
    func constraintEqualTo(with otherView: Any, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: otherView, attribute: attribute, multiplier: 1.0, constant: constant)
    }
    
    func constraintEqualTo(with otherView: Any, receiverAttribute: NSLayoutConstraint.Attribute, otherAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: receiverAttribute, relatedBy: .equal, toItem: otherView, attribute: otherAttribute, multiplier: 1.0, constant: 0.0)
    }
}
