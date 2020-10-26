//
//  AppMainDelegate.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

protocol BaseScreenDelegate: class {
    associatedtype DataType
    var data: [DataType] { get set }

    init(_ listener: @escaping () -> Void)
}
