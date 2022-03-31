//
//  BaseBinder.swift
//
//
//  Created by Amjadi on 2022. 01. 04..
//

import Foundation
import Combine

open class BaseBinder<VM: ViewModel, V: ScreenView>: Binder {

    public var subscribers = Set<AnyCancellable>()

    public weak var viewModel: VM!
    public weak var view: V!

    public init(viewModel: VM, view: V) {
        self.viewModel = viewModel
        self.view = view
    }

    open func bind() {
        // override this to bind view model to the view
    }

    deinit {
        print("binder deinitialised")
    }
}
