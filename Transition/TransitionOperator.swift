//
//  TransitionOperator.swift
//  Mega
//
//  Created by Tope Abayomi on 19/11/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class TransitionOperator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var isPresenting : Bool = false
    var transitionStyle : String = "presentSideNav"
    var snapshot : UIView!
    
    var offSetTransform : CGAffineTransform!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if(isPresenting){
            showNavigation(transitionContext)
        }else{
            dismissNavigation(transitionContext)
        }
    }
    
    func dismissNavigation(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.snapshot.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                transitionContext.completeTransition(true)
        })
    }
    
    func showNavigation(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        let descriptionLabel = (toViewController as ShotZoomController).descriptionLabel
        
        container.addSubview(toView)
        
        let offstageBottom = CGAffineTransformMakeTranslation(0, -1500)
        
        toView.alpha = 0;
        descriptionLabel.transform = offstageBottom
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            
            toView.alpha = 1
            descriptionLabel.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
        })
        
    }
    
    func showNavigation2(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        offSetTransform = createTransformForTransitionStyle(transitionStyle)
        
        snapshot = fromView.snapshotViewAfterScreenUpdates(true)
        
        container.addSubview(toView)
        container.addSubview(snapshot)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            
            self.snapshot.transform = self.offSetTransform
            
            }, completion: { finished in
                
                transitionContext.completeTransition(true)
        })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = false
        return self
    }
    
    func createTransformForTransitionStyle(style: String) -> CGAffineTransform {
        
        let size = UIScreen.mainScreen().bounds.size
        
        if style == "presentSideNavigation" {
            return CGAffineTransformMakeTranslation(60, 0)
        }else if style == "presentFullNavigation" {
            var transform = CGAffineTransformMakeTranslation(size.width - 120, 0)
            return CGAffineTransformScale(transform, 0.6, 0.6)
            
        }else if style == "presentTableNavigation" {
            return CGAffineTransformMakeTranslation(size.width - 50, 0)
        }else{
            return CGAffineTransformMakeTranslation(80, 0)
        }
    }
}
