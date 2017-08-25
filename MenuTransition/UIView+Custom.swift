//
//  UIView+Custom.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension UIView {
    
    func hitTestTargetSubviewWith(_ point: CGPoint, targetSubview: UIView) -> Bool {
        // hit test the point. If a view is returned, it may be a subview of the target subview. If the hit test view is not an immediate match, walk up the view hierarchy searching for the target subview. Stop when self is reached
        if var hitTestView = hitTest(point, with: nil) {
            while !(hitTestView === self) {
                if hitTestView === targetSubview {
                    return true
                }
                if let hitTestSuperview = hitTestView.superview {
                    print("traveling up view hierarchy")
                    hitTestView = hitTestSuperview
                } else {
                    return false
                }
            }
        }
        return false
    }
}
