//
//  MainViewController.swift
//  MVVMSampleApp
//
//  Created by Amjadi on 2022. 03. 30..
//

import UIKit
import os.log
import Magnetic
import Anchorage

class MainViewController: UITabBarController {

    private let screenProvider: IOSScreenProvider
    private let viewModel: MainViewModel

    private var importButton: UIButton!
    private var importFormatBackgroundView: UIView!
    private var magneticFormateView: MagneticView?
    private var containerViewController: HomeViewController?
    private var availableIdentifier: Int = 0
    private var selectedExportFormate: String = ""
    private let magneticFormateViewTitleLabel: UILabel = {

        let titleLabel = UILabel()
        titleLabel.text = "Please choose the conversion format for selected file"
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Avenir-Black", size: 28)
        return titleLabel
    }()

    private var importButtonExpansionFactor: (xScale: CGFloat, yScale: CGFloat) {
        let bounds = self.view.bounds
        let buttonSizeWidth = self.importButton.bounds.width
        return (bounds.width/buttonSizeWidth * 2.8, bounds.height/buttonSizeWidth * 2.8)
    }

    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         screenProvider: IOSScreenProvider,
         viewModel: MainViewModel) {

        self.screenProvider = screenProvider
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModel.loadConvertedModels()
    }

    func setDocument(_ document: Document, completion: @escaping () -> Void) {

        self.document = document

        document.open(completionHandler: { [weak self] (success) in
            if !success {
                self?.showAlert("Failed to open document")
            }
            completion()
        })

    }

    func presentDocumentDetails(at documentURL: URL, animated: Bool = true) {}

    fileprivate func onDataUpdated() {

        if viewModel.numberOfRunningConversionProcesses > 0 {
            if let cellData = data.last,
               let containerVCData = containerViewController?.data[cellData.index],
               let documentIdentifier = containerVCData.metadataModel?.uniqueIdentifier,
               containerVCData.isConverting == true {

                let document = cellData.document

                let documentMetadataModel = DocumentMetadataModel(uniqueIdentifier: documentIdentifier,
                                                                  fileURL: document.fileURL,
                                                                  localizedName: document.localizedName,
                                                                  fileType: cellData.exportFormate,
                                                                  fileModificationDate: document.fileModificationDate,
                                                                  data: cellData.data)

                containerViewController?.viewModel.updateData(with: (false, documentMetadataModel), at: cellData.index)

            } else {

                let documentMetadataModel = DocumentMetadataModel(uniqueIdentifier: availableIdentifier,
                                                                  fileURL: document?.fileURL,
                                                                  localizedName: document?.localizedName,
                                                                  fileType: selectedExportFormate,
                                                                  fileModificationDate: document?.fileModificationDate,
                                                                  data: nil)

                containerViewController?.viewModel.insert((true, documentMetadataModel))
            }
        }
    }

    private func setupViews() {

        importFormatBackgroundView = UIView()
        importFormatBackgroundView.backgroundColor = Constants.accentColor
        importFormatBackgroundView.alpha = 0
        navigationController?.view.addSubview(importFormatBackgroundView)

        importFormatBackgroundView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(60)
        }
        importFormatBackgroundView.setRoundCorners(with: 30)

        importButton = UIButton()
        importButton.backgroundColor = Constants.accentColor
        importButton.tintColor = .white
        importButton.setImage(Constants.importButtonImage, for: .normal)
        importButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
        navigationController?.view.addSubview(importButton)

        importButton.trailingAnchor == containerView.trailingAnchor + 24
        importButton.sizeAnchors == CGSize(width: 60, height: 60)


        importButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(60)
        }
        importButton.setRoundCorners(with: 30)
    }

    private func setupMagneticFormatterView() {

        let bounds = navigationController?.view.bounds ?? view.bounds
        let localmagneticFormateView = MagneticView(frame: bounds)

        magneticFormateView = localmagneticFormateView
        let magneticFormater = localmagneticFormateView.magnetic
        magneticFormater.allowsMultipleSelection = false
        magneticFormater.backgroundColor = Constants.accentColor
        magneticFormater.magneticDelegate = self

        FormateTypes.allCases.forEach { (formateType) in
            magneticFormater.addChild(formateType.node)
        }

        navigationController?.view.addSubview(localmagneticFormateView)

        importButton.bringSubviewToFront(localmagneticFormateView)

        let titleLabel = magneticFormateViewTitleLabel

        localmagneticFormateView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(74)
            make.leadingMargin.trailingMargin.equalToSuperview()
        }
    }

    private func hideExpandedConversionView() {

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn]) {
            self.importFormatBackgroundView.alpha = 0
            self.importFormatBackgroundView.transform = .identity
            self.importButton.transform = .identity
            self.importButton.backgroundColor = Constants.accentColor

        } completion: { _ in
            self.magneticFormateView?.removeFromSuperview()
            self.magneticFormateView = nil
        }

    }

    @objc
    private func importFile(_ sender: Any) {

        if magneticFormateView != nil {
            hideExpandedConversionView()

        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
                self.importFormatBackgroundView.alpha = 1
                let scaleFactor = self.importButtonExpansionFactor
                self.importButton.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.importButton.backgroundColor = UIColor(named: "AccentColorDark") ?? .blue
                self.importFormatBackgroundView.transform = CGAffineTransform(scaleX: scaleFactor.xScale,
                                                                              y: scaleFactor.yScale)
            } completion: { _ in

                let storyBoard = UIStoryboard(name: "DocumentBrowser", bundle: nil)
                let instantiatedViewController = storyBoard.instantiateInitialViewController()
                guard let documentBrowserViewController = instantiatedViewController as? DocumentBrowserViewController
                else { fatalError() }
                documentBrowserViewController.modalPresentationStyle = .overFullScreen
                documentBrowserViewController.receiverViewController = self

                self.present(documentBrowserViewController, animated: true, completion: nil)

                self.setupMagneticFormatterView()
            }
        }
    }
}

// MARK: State Preservation and Restoration

extension MainViewController {

    override func encodeRestorableState(with coder: NSCoder) {

        if let documentURL = document?.fileURL {
            do {
                let didStartAccessing = documentURL.startAccessingSecurityScopedResource()
                defer {
                    if didStartAccessing {
                        documentURL.stopAccessingSecurityScopedResource()
                    }
                }
                let bookmarkData = try documentURL.bookmarkData()

                coder.encode(bookmarkData, forKey: MainViewController.bookmarkDataKey)

            } catch {
                os_log("Failed to get bookmark data from URL %@: %@",
                       log: OSLog.default, type: .error, documentURL as CVarArg, error as CVarArg)

                showAlert("Failed to get bookmark data from URL \(documentURL): \(error)")
            }
        }

        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {

        if let bookmarkData = coder.decodeObject(of: NSData.self, forKey: MainViewController.bookmarkDataKey) as Data? {
            do {
                var bookmarkDataIsStale: Bool = false
                let documentURL = try URL(resolvingBookmarkData: bookmarkData,
                                          bookmarkDataIsStale: &bookmarkDataIsStale)
                presentDocumentDetails(at: documentURL, animated: false)
            } catch {
                os_log("Failed to create document URL from bookmark data: %@, error: %@",
                       log: OSLog.default, type: .error, bookmarkData as CVarArg, error as CVarArg)

                showAlert("Failed to create document URL from bookmark data \(bookmarkData): \(error)")
            }
        }
        super.decodeRestorableState(with: coder)
    }
}

// MARK: - MagneticDelegate

extension MainViewController: MagneticDelegate {

    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        hideExpandedConversionView()

        guard let document = document else { return }

        selectedExportFormate = node.text ?? ""

        availableIdentifier = containerViewController?.data.compactMap({
            $0.metadataModel?.uniqueIdentifier
        }).getFirstFreeInt() ?? 0

        let index = containerViewController?.data.count ?? 0
        viewModel.convert(document, to: selectedExportFormate, at: index, with: availableIdentifier)

        hideExpandedConversionView()
        onDataUpdated()
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) { self.hideExpandedConversionView() }
}

// MARK: - Constants

fileprivate enum Constants {
    static let bookmarkDataKey = "bookmarkData"
    static let accentColor = UIColor(named: "AccentColor") ?? .blue
    static let importButtonImage = UIImage(systemName: "plus")
}
