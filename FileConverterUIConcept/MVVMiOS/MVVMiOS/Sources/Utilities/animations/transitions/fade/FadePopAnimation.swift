//
//  FadePopAnimation.swift
//
//
//  Created by Amjadi on 2022. 01. 07..
//

import UIKit

open class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                
                return
        }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
