//
//  PopAnimator.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2019. 8. 8..
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let durationExpanding = 0.75
    let durationClosing = 0.3
    var presenting = true
    var originFrame = CGRect.zero

    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return presenting ? durationExpanding : durationClosing
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to),
              let detailView = presenting ? toView: transitionContext.view(forKey: .from)
        else { return }

        let initialFrame = presenting ? originFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : originFrame
        let xScaleFactor = (presenting ?
                                initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width)
        let yScaleFactor = (presenting ?
                                initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height)
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)

        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint( x: initialFrame.midX, y: initialFrame.midY)
            detailView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)

        if presenting {
            //update opening animation
            UIView.animate(withDuration: durationExpanding, delay: 0.0,
                           usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,
                           animations: {
                            detailView.transform = CGAffineTransform.identity
                            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                           },
                           completion: { _ in
                            transitionContext.completeTransition(true)
                           }
            )
        } else {
            //update closing animation
            UIView.animate(withDuration: durationClosing, delay: 0.0, options: .curveLinear,
                           animations: {
                            detailView.transform = scaleTransform
                            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                           },
                           completion: { _ in
                            if !self.presenting {
                                self.dismissCompletion?()
                            }
                            transitionContext.completeTransition(true)
                           }
            )
        }
    }

}
