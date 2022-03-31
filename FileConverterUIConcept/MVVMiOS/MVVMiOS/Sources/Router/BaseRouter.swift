//
//  BaseRouter.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import UIKit

open class BaseRouter {

    public weak var viewController: BaseViewController?
    public var screenProvider: ScreenProvider?

    public init(screenProvider: ScreenProvider) {
        self.screenProvider = screenProvider
    }
}
