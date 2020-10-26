//
//  MainViewController.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit
import Magnetic
import SnapKit
import os.log

enum FormateTypes: String, CaseIterable {
    case step = ".step"
    case stl = ".stl"
    case obj = ".obj"

    var node: Node {
        let node = Node(text: self.rawValue, image: nil, color: .white, radius: 75)
        node.fontColor = .black
        node.fontSize = 32
        return node
    }
}

class MainDelegateImpl: BaseScreenDelegate {

    typealias DataType = (document: Document, data: Data, exportFormate: String?, index: Int)

    private var dataUpdateListener: () -> Void

    var data = [(document: Document, data: Data, exportFormate: String?, index: Int)]() { didSet { dataUpdateListener() } }

    var exportFormatSelected = false

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}

class MainViewController: BaseViewController<MainDelegateImpl, MainViewModel> {

    @IBOutlet weak var containerView: UIView!

    static let bookmarkDataKey = "bookmarkData"

    var document: Document?

    private var importButton: UIButton!
    private var importFormatBackgroundView: UIView!
    private var magneticFormateView: MagneticView?
    private var containerViewController: HomeViewController?
    private var accentColor = UIColor(named: "AccentColor") ?? .blue
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func onDataUpdated() {

        if let data = delegateImpl.data.last,
           containerViewController?.delegateImpl.data[data.index].isConverting == true {

            let document = data.document

            let documentMetadataModel = DocumentMetadataModel(fileURL: document.fileURL,
                                                              localizedName: document.localizedName,
                                                              fileType: data.exportFormate,
                                                              fileModificationDate: document.fileModificationDate,
                                                              data: data.data)

            containerViewController?.delegateImpl.data[data.index] = (false, documentMetadataModel)
        } else {
            let documentMetadataModel = DocumentMetadataModel(fileURL: document?.fileURL,
                                                              localizedName: document?.localizedName,
                                                              fileType: selectedExportFormate,
                                                              fileModificationDate: document?.fileModificationDate,
                                                              data: nil)

            containerViewController?.delegateImpl.data.append((true, documentMetadataModel))
        }
    }

    func setDocument(_ document: Document, completion: @escaping () -> Void) {

        self.document = document

        document.open(completionHandler: { (success) in

            if success {
            }
            completion()
        })

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerSegue" {
            containerViewController = segue.destination as? HomeViewController
        }
    }

    func presentDocumentDetails(at documentURL: URL, animated: Bool = true) {

        let storyBoard = UIStoryboard(name: "DocumentDetails", bundle: nil)
        let instantiatedViewController = storyBoard.instantiateInitialViewController()
        guard let documentViewController = instantiatedViewController as? DocumentViewController else { fatalError() }
        documentViewController.modalPresentationStyle = .overFullScreen

        documentViewController.document = self.document

        present(documentViewController, animated: animated, completion: nil)
    }

    private func setupViews() {

        importFormatBackgroundView = UIView()
        importFormatBackgroundView.backgroundColor = accentColor
        importFormatBackgroundView.alpha = 0
        navigationController?.view.addSubview(importFormatBackgroundView)

        importFormatBackgroundView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(60)
        }
        importFormatBackgroundView.setRoundCorners(with: 30)

        importButton = UIButton()
        importButton.backgroundColor = accentColor
        importButton.tintColor = .white
        importButton.setImage(UIImage(systemName: "plus"), for: .normal)
        importButton.addTarget(self, action: #selector(importFile), for: .touchUpInside)
        navigationController?.view.addSubview(importButton)

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
        magneticFormater.backgroundColor = accentColor
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

    @objc
    func importFile(_ sender: Any) {

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

    private func hideExpandedConversionView() {

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn]) {
            self.importFormatBackgroundView.alpha = 0
            self.importFormatBackgroundView.transform = .identity
            self.importButton.transform = .identity
            self.importButton.backgroundColor = self.accentColor

        } completion: { _ in
            self.magneticFormateView?.removeFromSuperview()
            self.magneticFormateView = nil
        }

    }

    // MARK: State Preservation and Restoration

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

                showErrorAlert("Failed to get bookmark data from URL \(documentURL): \(error)")
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

                showErrorAlert("Failed to create document URL from bookmark data \(bookmarkData): \(error)")
            }
        }
        super.decodeRestorableState(with: coder)
    }
}

extension MainViewController: MagneticDelegate {

    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        hideExpandedConversionView()

        guard let document = document else { return }

        selectedExportFormate = node.text ?? ""

        let index = containerViewController?.delegateImpl.data.count ?? 0
        viewModel.convert(document, to: selectedExportFormate, at: index)

        hideExpandedConversionView()
        onDataUpdated()
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) { self.hideExpandedConversionView() }
}
