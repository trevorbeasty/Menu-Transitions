//
//  MenuPresenter.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class MenuSlideInPresenter: UIPresentationController {
    
    let coverage: CGFloat
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, coverage: CGFloat) {
        self.coverage = coverage
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    fileprivate var blurView: UIView!
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerFrame = containerView!.frame
        return CGRect(
            x: (1.0 - coverage) * containerFrame.width,
            y: 0.0,
            width: containerFrame.width * coverage,
            height: containerFrame.height)
    }
    
    override func presentationTransitionWillBegin() {
        if blurView == nil {
            setupBlurView()
        }
        
        animateBlurViewAlphaAlongsideTransition(1.0)
    }
    
    override func dismissalTransitionWillBegin() {
        animateBlurViewAlphaAlongsideTransition(0.0)
    }
    
    func animateBlurViewAlphaAlongsideTransition(_ alpha: CGFloat) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurView.alpha = alpha
            return
        }
        
        coordinator.animate(
            alongsideTransition:  { _ in
                self.blurView.alpha = alpha
        },
            completion: nil)
    }
    
    func setupBlurView() {
        blurView = UIView(frame: .zero)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedController))
        blurView.addGestureRecognizer(tap)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        containerView?.insertSubview(blurView, at: 0)
        
        let views = ["blur" : blurView!]
        
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[blur]-0-|", options: [], metrics: nil, views: views).forEach( { constraint in
            constraint.isActive = true
        })
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[blur]-0-|", options: [], metrics: nil, views: views).forEach( { constraint in
            constraint.isActive = true
        })
        
        blurView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        blurView.alpha = 0.0
    }
    
    func dismissPresentedController() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
}
