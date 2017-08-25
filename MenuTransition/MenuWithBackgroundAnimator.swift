//
//  MenuAnimator_2.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

enum MenuOrientation {
    case MenuLeft
    case MenuRight
}

class MenuWithBackgroundAnimator: NSObject {
    
    var backgroundImage: UIImage
    
    var duration: TimeInterval = 0.5
    var presentedCoverage: CGFloat = 0.7
    var presentedAnimationScale: CGFloat = 0.6
    var presentedAnimationCenterXTranslation: CGFloat = 60.0
    var presentingAnimationScale: CGFloat = 0.4
    
    var menuOrientation: MenuOrientation = .MenuLeft
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
        
        if presenting {
            presentedView.frame = transitionContext.finalFrame(for: presentedController)
            presentedView.center.x -= presentedAnimationCenterXTranslation
            presentedView.transform = presentedSizeTransform
            presentedView.alpha = 0.0
            container.addSubview(presentedView)
        }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                presentedView.center.x += self.presentedViewCenterTranslation(presenting: self.presenting, orientation: self.menuOrientation, offset: self.presentedAnimationCenterXTranslation)
                presentedView.transform = self.finalPresentedViewTransform(presenting: self.presenting, scale: self.presentedAnimationScale)
                presentedView.alpha = self.presenting ? 1.0 : 0.0
                
                presentingView.transform = self.finalPresentingViewTransform(presenting: self.presenting , scale: self.presentingAnimationScale)
                presentingView.center = self.finalPresentingCenter(presenting: self.presenting, orientation: self.menuOrientation, container: container)
        },
            completion: { completed in
                transitionContext.completeTransition(true)
        })
    }
    
    private func finalPresentingCenter(presenting: Bool, orientation: MenuOrientation, container: UIView) -> CGPoint {
        let center: CGPoint
        
        switch presenting {
        case true where orientation == .MenuRight:
            center = CGPoint(x: 0.0, y: container.center.y)
            
        case true where orientation == .MenuLeft:
            center = CGPoint(x: container.frame.width, y: container.center.y)
            
        case false:
            center = container.center
            
        default:
            center = container.center
        }
        
        return center
    }
    
    private func finalPresentingViewTransform(presenting: Bool, scale: CGFloat) -> CGAffineTransform {
        let transform: CGAffineTransform
        
        switch presenting {
        case true:
            transform = CGAffineTransform(scaleX: scale, y: scale)
            
        case false:
            transform = .identity
        }
        
        return transform
    }
    
    private func presentedViewCenterTranslation(presenting: Bool, orientation: MenuOrientation, offset: CGFloat) -> CGFloat {
        var translation: CGFloat
        
        switch presenting {
        case true where orientation == .MenuRight:
            translation = offset
            
        case true where orientation == .MenuLeft:
            translation = -1.0 * offset
            
        case false where orientation == .MenuRight:
            translation = -1.0 * offset
            
        case false where orientation == .MenuLeft:
            translation = offset
            
        default:
            translation = 0.0
        }
        
        return translation
    }
    
    private func finalPresentedViewTransform(presenting: Bool, scale: CGFloat) -> CGAffineTransform {
        let transform: CGAffineTransform
        
        switch presenting {
        case false:
            transform = CGAffineTransform(scaleX: scale, y: scale)
            
        case true:
            transform = .identity
        }
        
        return transform
    }

}











