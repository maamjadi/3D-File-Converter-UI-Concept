//
//  HomeViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit

// MARK: - BaseScreenDelegate

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

// MARK: - UIViewController

class HomeViewController: BaseViewController<HomeDelegateImpl, HomeViewModel> {

    @IBOutlet weak var collectionView: UICollectionView!

    private let transition = PopAnimator()
    private let cellIdentifier = "homeCell"

    private var selectedCell = UICollectionViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        transition.dismissCompletion = {
            self.selectedCell.isHidden = false
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let detailsViewController = segue.destination as? DocumentViewController,
            let documentMetadata = sender as? DocumentMetadataModel {

            detailsViewController.documentMetadata = documentMetadata
            detailsViewController.transitioningDelegate = self
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

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
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell,
              let documentMetadata = cell.metadataModel else { return }

        if cell.isConverting {
            showAlert("File under conversion, please wait!", title: "Warning")

        } else {
            selectedCell = cell

            let storyBoard = UIStoryboard(name: "DocumentDetails", bundle: nil)
            let instantiatedViewController = storyBoard.instantiateInitialViewController()

            if let detailsViewController = instantiatedViewController as? DocumentViewController {
                detailsViewController.documentMetadata = documentMetadata
                detailsViewController.transitioningDelegate = self
                detailsViewController.modalPresentationStyle = .fullScreen
                navigationController?.present(detailsViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil)
        else { return transition }

        transition.originFrame = originFrame
        transition.presenting = true
        selectedCell.isHidden = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
