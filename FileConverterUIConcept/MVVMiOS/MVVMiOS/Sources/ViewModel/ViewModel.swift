//
//  ViewModel.swift
//  
//
//  Created by Amjadi on 2022. 01. 04..
//

import Foundation

public protocol ViewModel: AnyObject {
    func setViewController(viewController: BaseViewController)
    func viewModelDidLoad()
    func viewDidAppear()
    func viewWillAppear()
    func viewDidDisappear()
    func viewWillDisappear()
}
