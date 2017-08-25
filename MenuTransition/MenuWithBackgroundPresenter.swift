//
//  MenuPresenter_2.swift
//  MenuTransition
//
//  Created by Trevor Beasty on 8/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class MenuWithBackgroundPresenter: UIPresentationController {
    
    let coverage: CGFloat
    let backgroundImage: UIImage
    
    var backgroundImageView: UIImageView!
    var dismissalTap: UITapGestureRecognizer!
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, coverage: CGFloat, backgroundImage: UIImage) {
        self.coverage = coverage
        self.backgroundImage = backgroundImage
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
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
        backgroundImageView = setUpImageView()
        dismissalTap = setUpTap()
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        backgroundImageView.removeFromSuperview()
    }


    func setUpImageView() -> UIImageView {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "rabbits"))
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        presentingViewController.view.superview?.insertSubview(imageView, at: 0)
        
        let views = ["image" : imageView]
        
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: [], metrics: nil, views: views).forEach( { constraint in
            constraint.isActive = true
        })
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[image]-0-|", options: [], metrics: nil, views: views).forEach( { constraint in
            constraint.isActive = true
        })
        
        return imageView
    }
    
    func setUpTap() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        tap.cancelsTouchesInView = false
        containerView?.addGestureRecognizer(tap)
        return tap
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        if let presentedView = presentedViewController.view {
            let tappedPresentedView = sender.hitTest(targetSubview: presentedView)
            if tappedPresentedView == false {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}












