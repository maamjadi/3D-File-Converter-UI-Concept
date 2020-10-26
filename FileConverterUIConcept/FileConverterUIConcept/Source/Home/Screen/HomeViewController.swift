//
//  HomeViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit

class HomeDelegateImpl: BaseScreenDelegate {

    typealias DataType = (isConverting: Bool, metadataModel: DocumentMetadataModel?)

    private var dataUpdateListener: () -> Void

    var data = [(isConverting: Bool, metadataModel: DocumentMetadataModel?)]() {
        didSet { dataUpdateListener() }
    }

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
        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel.loadConvertedFiles()
    }

    override func onDataUpdated() { collectionView.reloadData() }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegateImpl.data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                as? HomeCollectionViewCell else { return UICollectionViewCell() }

        let data = delegateImpl.data[indexPath.row]

        cell.isConverting = data.isConverting
        cell.metadataModel = data.metadataModel

        return cell
    }
}
