//
//  MainViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2022. 03. 31..
//

import Foundation
import DataAccess
import FileConverterKit

// MARK: - FormateTypes

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

// MARK: - MainViewModel

class MainViewModel {

    var numberOfRunningConversionProcesses = 0 {
        didSet {
            if numberOfRunningConversionProcesses == 0 {
                delegate?.data = []
                removedDataIndices = []
            }
        }
    }

    private let storageDataRepository: StorageDataRepository
    private var removedDataIndices: [Int] = []

    init(with storageDataRepository: StorageDataRepository) {
        self.storageDataRepository = storageDataRepository
    }

    func convert(_ document: Document, to exportFormate: String? = nil, at index: Int, with uniqueIdentifier: Int) {

        numberOfRunningConversionProcesses += 1

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let data = FileConverterKit.Converter.convert(document.data, to: exportFormate)

            DispatchQueue.main.async { [weak self] in
                var decreaseIndexFactor = 0

                self?.removedDataIndices.forEach {
                    if $0 < index { decreaseIndexFactor += 1 }
                }
                self?.delegate?.data.append((document,
                                             data,
                                             exportFormate,
                                             index-decreaseIndexFactor,
                                             uniqueIdentifier))
                document.close(completionHandler: nil)
                self?.numberOfRunningConversionProcesses -= 1
            }
        }
    }

    func deleteDocument(with identifier: Int, removedCellIndex: Int) {

        if numberOfRunningConversionProcesses > 0 {
            removedDataIndices.append(removedCellIndex)
        }

        storageDataRepository.deleteDocument(with: identifier, removedCellIndex: removedCellIndex)
    }

    func addOrUpdateDocument(from content: DocumentMetadataModel) {
        storageDataRepository.addOrUpdateDocument(from: content)
    }
}
