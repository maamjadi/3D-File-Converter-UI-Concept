//
//  ScreenViewController.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit

/// View Controller that wraps the ScreenView objects.
/// It provides lifecycle events to the view model and ScreenView objects
open class ScreenViewController: BaseViewController {

    public var screenView: ScreenView?

    public init(screenView: ScreenView) {
        self.screenView = screenView
        super.init()

        self.screenView?.setViewController(viewController: self)
    }

    public required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {
        super.loadView()
        
        if let rootView = screenView as? UIView {
            
            //zero width and zero size at init breaks the contraints
            let temporaryBounds = CGRect(x: 0.0, y: 0.0, width: 1000.0, height: 1000.0)
            
            rootView.bounds = temporaryBounds
            rootView.translatesAutoresizingMaskIntoConstraints = true
            self.view = rootView
        }

        self.setNavigationBarVisibility(hidden: true, animated: false)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        screenView?.viewDidLoad()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenView?.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        screenView?.viewDidAppear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        screenView?.viewDidDisappear(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        screenView?.viewWillDisappear(animated)
    }

    open override func didConfigureLayout() {
        super.didConfigureLayout()

        screenView?.didConfigureLayout()
    }

    #if os(iOS)
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return screenView?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.all
    }

    open override var shouldAutorotate: Bool {
        return screenView?.shouldAutorotate ?? false
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        screenView?.viewWillTransition(to: size, with: coordinator)
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        screenView?.willTransition(to: newCollection, with: coordinator)
    }
    #endif

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.screenView?.willDismissScreen()
        super.dismiss(animated: flag, completion: completion)
    }

    deinit {
        print("screen view controller deinitialised")
    }
}
