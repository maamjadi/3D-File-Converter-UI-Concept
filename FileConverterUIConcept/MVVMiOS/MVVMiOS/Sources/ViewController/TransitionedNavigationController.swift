//
//  TransitionedNavigationController.swift
//  
//
//  Created by Amjadi on 2022. 01. 07..
//

import UIKit

open class TransitionedNavigationController: UINavigationController, UINavigationControllerDelegate {

    public var pushTransition: UIViewControllerAnimatedTransitioning?

    public var popTransition: UIViewControllerAnimatedTransitioning?

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     animationControllerFor operation: UINavigationController.Operation,
                                     from fromVC: UIViewController,
                                     to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {

        case .push:
            return pushTransition

        case .pop:
            return popTransition

        default:
            return nil
        }
    }

    #if os(iOS)
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {

        return visibleViewController?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.all
    }

    open override var shouldAutorotate: Bool {

        return visibleViewController?.shouldAutorotate ?? true
    }
    #endif
}

