//
//  MainViewController.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 03. 30..
//

import UIKit

class MainViewController: UITabBarController {

    private let screenProvider: IOSScreenProvider

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         screenProvider: IOSScreenProvider) {

        self.screenProvider = screenProvider
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
