//
//  MenuAnimator_2.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit



class MenuWithBackgroundAnimator: NSObject {
    
    var backgroundImage: UIImage
    
    var duration: TimeInterval = 0.5
    var presentedCoverage: CGFloat = 0.7
    var presentedAnimationScale: CGFloat = 0.6
    var presentedAnimationCenterXTranslation: CGFloat = 60.0
    var presentingAnimationScale: CGFloat = 0.4
    var presentingAnimationCenterX: CGFloat = 0.0
    
    var presenting = true
    
    init(backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
    }
}

extension MenuWithBackgroundAnimator: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MenuWithBackgroundPresenter(presentedViewController: presented, presenting: presenting, coverage: presentedCoverage, backgroundImage: backgroundImage)
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

extension MenuWithBackgroundAnimator: UIViewControllerAnimatedTransitioning {
    
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
        
        let presentedSizeTransform = CGAffineTransform(scaleX: presentedAnimationScale, y: presentedAnimationScale)
        
        let finalPresentedFrame = transitionContext.finalFrame(for: presentedController)
        
        if presenting {
            presentedView.frame = finalPresentedFrame
            presentedView.center.x -= presentedAnimationCenterXTranslation
            presentedView.transform = presentedSizeTransform
            presentedView.alpha = 0.0
            container.addSubview(presentedView)
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                let plusMinus: CGFloat = self.presenting ? 1.0 : -1.0
                presentedView.center.x += self.presentedAnimationCenterXTranslation * plusMinus
                presentedView.transform = self.presenting ? .identity : presentedSizeTransform
                presentedView.alpha = self.presenting ? 1.0 : 0.0
                
                let finalPresentingTransform: CGAffineTransform = self.presenting ? CGAffineTransform(scaleX: self.presentingAnimationScale, y: self.presentingAnimationScale) : .identity
                let finalPresentingCenter = self.presenting ? CGPoint(x: self.presentingAnimationCenterX, y: container.center.y) : container.center
                presentingView.transform = finalPresentingTransform
                presentingView.center = finalPresentingCenter
        },
            completion: { completed in
                transitionContext.completeTransition(true)
        })
    }
}











