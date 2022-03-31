//
//  ScreenView.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit

public protocol ScreenView: AnyObject {
    var shouldAutorotate: Bool { get }
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func setViewController(viewController: BaseViewController)
    func didConfigureLayout()
    func willDismissScreen()

    #if os(iOS)
    var supportedInterfaceOrientations: UIInterfaceOrientationMask { get }
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    #endif
}
