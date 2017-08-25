//
//  SlideAnimator.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class MenuSlideInAnimator: NSObject {
    
    var duration: TimeInterval = 0.5
    var presentedWidthCoverage: CGFloat = 0.7
    var presenting = true
    

}

extension MenuSlideInAnimator: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MenuSlideInPresenter(presentedViewController: presented, presenting: presenting, coverage: presentedWidthCoverage)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}

extension MenuSlideInAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let presentedKey = presenting ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let presentingKey = presenting ? UITransitionContextViewControllerKey.from : UITransitionContextViewControllerKey.to
        
        let presentedController = transitionContext.viewController(forKey: presentedKey)!
        let presentinigController = transitionContext.viewController(forKey: presentingKey)!
        
        let presentedView = presentedController.view!
        let presentingView = presentinigController.view!
        
        if presenting {
            let finalPresentedFrame = transitionContext.finalFrame(for: presentedController)
            var initialPresentedFrame = finalPresentedFrame
            initialPresentedFrame.origin.x += finalPresentedFrame.width
            presentedView.frame = initialPresentedFrame
            container.addSubview(presentedView)
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                let views = [presentedView, presentingView]
                
                var translationX = presentedView.frame.width
                let direction: CGFloat = self.presenting ? -1.0 : 1.0
                translationX *= direction
                
                for view in views {
                    view.frame.origin.x += translationX
                }
        },
            completion: { completed in
                transitionContext.completeTransition(true)
        })
    }
}














