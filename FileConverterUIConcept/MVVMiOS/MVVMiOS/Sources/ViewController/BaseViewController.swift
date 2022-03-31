//
//  BaseViewController.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit
import Combine
public enum OrientationChangeState {
    case willChange
    case didChange
}

#if os(iOS)
public typealias OrientationState = (OrientationChangeState, UIDeviceOrientation, UIInterfaceOrientation)
#endif

open class BaseViewController: UIViewController {

    public var subscribers = Set<AnyCancellable>()

#if os(iOS)
    public let orientationStateRelay = PassthroughSubject<OrientationState, Never>()

    public var isHomeIndicatorAutoHidden = false {
        didSet {
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }

    open override var prefersHomeIndicatorAutoHidden: Bool { self.isHomeIndicatorAutoHidden }
#endif

    private var forcedFocusEnvironment: UIFocusEnvironment?

    private var orientation: UIInterfaceOrientation {
        return (UIApplication.shared.windows
                    .first?
                    .windowScene?
                    .interfaceOrientation ?? .portrait)
    }

    // MARK: - Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("[\(self)] constructor with Nib called.")
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("[\(self)] constructor from Storyboard or Xib called.")
    }

    deinit {
        print("[\(self)] View Controller deinitialised")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        print("[\(self)] view loaded.")

        setupUI()
        bind()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

#if os(iOS)
        self.orientationStateRelay.send((.didChange, UIDevice.current.orientation, orientation))
#endif
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.didConfigureLayout()
    }

    func didConfigureLayout() {
        // override to get notified when autolayout is configured
    }

    func setupUI() {
        // setup UI in this method
    }

    func bind() {
        // bind UI in this method
    }

    // MARK: - Utility

    open func setNavigationBarVisibility(hidden: Bool = true, animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }

    func setFocus(on environment: UIFocusEnvironment) {
        self.forcedFocusEnvironment = environment
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

#if os(iOS)
        self.orientationStateRelay.send((.willChange, UIDevice.current.orientation, orientation))
        _ = coordinator.animate(alongsideTransition: nil) { [weak self] _ in

            if let self = self {
                self.orientationStateRelay.send((.didChange, UIDevice.current.orientation, self.orientation))
            }
        }
#endif
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
    }
}
