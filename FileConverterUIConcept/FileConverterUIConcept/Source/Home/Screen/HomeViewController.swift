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

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = 75
    }

    override func onDataUpdated() {
        let contentOffset = collectionView.contentOffset

        if let updatedDataIndex = viewModel.updatedDataIndex {
            let indexPath = IndexPath(row: updatedDataIndex, section: 0)

            if collectionView.cellForItem(at: indexPath) != nil,
               collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.reloadItems(at: [indexPath])

                collectionView.layoutIfNeeded()
                collectionView.setContentOffset(contentOffset, animated: false)

            } else { collectionView.insertItems(at: [indexPath]) }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                as? HomeCollectionViewCell else { return UICollectionViewCell() }

        let data = self.data[indexPath.row]

        cell.isConverting = data.isConverting
        cell.metadataModel = data.metadataModel

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
