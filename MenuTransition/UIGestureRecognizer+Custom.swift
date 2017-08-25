//
//  UIGestureRecognizer+Custom.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/25/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
    
    func hitTest(targetSubview: UIView) -> Bool {
        if let view = view {
            let point = location(in: view)
            return view.hitTestTargetSubviewWith(point, targetSubview: targetSubview)
        }
        return false
    }
}
