//
//  AppMainViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class BaseViewController<T: BaseScreenDelegate, VM: BaseViewModel<T>>: UIViewController {

    private var _viewModel: VM!
    private var _delegateImpl: T!

    //Warning: Do not access the viewModel object before presentation of the ViewController
    var viewModel: VM { _viewModel }
    var data: [T.DataType] { _delegateImpl.data }

    override func viewDidLoad() {
        super.viewDidLoad()

        _delegateImpl = T(onDataUpdated)
        _viewModel = VM(_delegateImpl)
    }

    //This function is called when the data is updated
    func onDataUpdated() {}
}
