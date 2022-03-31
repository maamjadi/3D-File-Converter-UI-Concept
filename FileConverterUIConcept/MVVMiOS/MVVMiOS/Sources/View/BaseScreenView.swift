//
//  BaseScreenView.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit
import Combine

/// Screen view base class. Subclass it to provide your screen with a view
open class BaseScreenView<VM: ViewModel>: UIView, ScreenView {

    public var subscribers = Set<AnyCancellable>()

    open var shouldAutorotate: Bool { true }

    /// Loads the XIB for this View.
    /// The XIB name is the same as the class name by default
    /// Override it to change the XIB name
    open var nibName: String {
        let classType = type(of: self)
        return String(describing: classType)
    }

    /// The view model for this view
    public let viewModel: VM

    /// The binder for this view
    private var binder: Binder?

    public weak var controller: BaseViewController?

    public weak var nibView: UIView?

    public var tabBarController: UITabBarController? { controller?.tabBarController }

    private var forcedFocusEnvironment: UIFocusEnvironment?

#if os(iOS)
    public var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }

    open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
#endif

    public init(viewModel: VM) {
        self.viewModel = viewModel

        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false

        loadNib()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    /// Sets the view controller for the view model
    public func setViewController(viewController: BaseViewController) {
        self.controller = viewController
        self.viewModel.setViewController(viewController: viewController)
    }

    /// Sets the binder for this view
    public func setBinder(_ binder: Binder) {
        self.binder = binder
    }

    /// Called when the view including its XIB is loaded
    open func viewDidLoad() {
        self.viewModel.viewModelDidLoad()
        self.bind()
        self.setupUI()

#if os(iOS)
        self.observeOrientationChange()
#endif
    }

    /// Called before the view appears
    open func viewWillAppear(_ animated: Bool) {
        self.viewModel.viewWillAppear()
    }

    open func viewDidAppear(_ animated: Bool) {
        self.viewModel.viewDidAppear()
    }
    
    open func viewDidDisappear(_ animated: Bool) {
        self.viewModel.viewDidDisappear()
    }

    open func viewWillDisappear(_ animated: Bool) {
        self.viewModel.viewWillDisappear()
    }

    /// Called when auto layout is fully configured
    open func didConfigureLayout() {
    }

    private func loadNib() {
        if let contentView = Bundle.main.loadNibNamed(self.nibName, owner: self, options: nil)?.first as? UIView {
            self.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.layoutAttachAll(to: self)

            self.nibView = contentView
        }
    }

    private func bind() {
        binder?.bind()
    }

    /// Called on viewDidLoad
    open func setupUI() {
    }

    // Orientation Change
#if os(iOS)
    private func observeOrientationChange() {
        self.controller?.orientationStateRelay
            .sink { [weak self] stateTextField in
                self?.viewChangeOrientationState(to: stateTextField)
            }
            .store(in: &subscribers)
    }

    open func viewChangeOrientationState(to stateTextField: OrientationState) {
        // override to get notified about the orientation state changes
    }

    public func forceOrientation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(Int(orientation.rawValue), forKey: "orientation")
    }

    public func forcePortraitOrientationIfNeeded() {
        if isLandscape &&
            UIDevice.current.userInterfaceIdiom == .phone {
            self.forceOrientation(UIInterfaceOrientation.portrait)
        }
    }

    public func addTapToDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    @objc
    public func dismissKeyboard() {
        endEditing(true)
    }

    public func updateOrientation(coordinator: UIViewControllerTransitionCoordinator? = nil) {
        if let coordinator = coordinator {
            coordinator.animate(alongsideTransition: { _ in
                if self.isLandscape {
                    self.switchToLandscape()
                } else {
                    self.switchToPortrait()
                }
            })
        } else {
            if self.isLandscape {
                self.switchToLandscape()
            } else {
                self.switchToPortrait()
            }
        }
    }

    open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateOrientation(coordinator: coordinator)
    }

    open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.updateOrientation(coordinator: coordinator)
    }
#endif

    open func switchToLandscape() {
        // override to change the orientation to landscape
        NotificationCenter.default.post(Notification(name: .DidChangeOrientationNotification))
    }

    open func switchToPortrait() {
        // override to change the orientation to portrait
        NotificationCenter.default.post(Notification(name: .DidChangeOrientationNotification))
    }

    open func willDismissScreen() {
        // override to get notified when screen is dismissed
    }

    deinit {
        print("screen view is deinitialised")
    }

    public func setFocus(on environment: UIFocusEnvironment) {
        self.forcedFocusEnvironment = environment

        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
    }
}

public extension BaseScreenView {

    var isRootScreen: Bool { self.controller?.navigationController?.viewControllers.count == 1 }
}

extension NSNotification.Name {

    public static let DidChangeOrientationNotification = Notification.Name("DidChangeOrientationNotification")
}

extension UIView {

    func layoutAttachAll(to childView: UIView) {
        var constraints = [NSLayoutConstraint]()

        childView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))

        childView.addConstraints(constraints)
    }
}
