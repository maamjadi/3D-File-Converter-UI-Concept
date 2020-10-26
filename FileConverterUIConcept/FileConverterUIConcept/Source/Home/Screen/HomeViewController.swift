//
//  HomeViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit

class HomeDelegateImpl: BaseScreenDelegate {

    typealias DataType = Data

    private var dataUpdateListener: () -> Void

    var data = [Data]() { didSet { dataUpdateListener() } }

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}

class HomeViewController: BaseViewController<HomeDelegateImpl, HomeViewModel> {

    @IBOutlet weak var collectionView: UICollectionView!

    private let cellIdentifier = "homeCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: cellIdentifier)

        viewModel.loadConvertedFiles()
    }
}
