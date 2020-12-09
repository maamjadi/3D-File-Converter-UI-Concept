//
//  AppMainDelegate.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

// MARK: - BaseScreenDelegate

protocol BaseScreenDelegate: class {
    associatedtype DataType
    var data: [DataType] { get set }

    init(_ listener: @escaping () -> Void)
}

// MARK: - BaseScreenDelegate implementaiton

class BaseScreenDelegateImpl: BaseScreenDelegate {

    typealias DataType = (Void)

    private var dataUpdateListener: () -> Void

    var data: [DataType] = [DataType]() {
        didSet { dataUpdateListener() }
    }

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}
