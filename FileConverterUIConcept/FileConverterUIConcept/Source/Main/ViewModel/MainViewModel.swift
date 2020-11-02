//
//  MainViewModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import Foundation
import FileConverterKit
import Magnetic
import CoreData

class MainViewModel: BaseViewModel<MainDelegateImpl> {

    private var mainContext: NSManagedObjectContext!
    private var removedDataIndices: [Int] = []
    var numberOfRunningConversionProcesses = 0 {
        didSet {
            if numberOfRunningConversionProcesses == 0 {
                delegate?.data = []
                removedDataIndices = []
            }
        }
    }

    override func initialized() {
        let container = NSPersistentContainer.create(for: "FileConverterUIConcept")
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = container.viewContext
    }

    func loadConvertedModels() -> [DocumentMetadataModel] {
        return DocumentEntity.getItems(in: mainContext)?.compactMap({
            DocumentMetadataModel(from: $0)
        }) ?? []
    }

    func convert(_ document: Document,
                 to exportFormate: String? = nil,
                 at index: Int,
                 with uniqueIdentifier: Int) {

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

        DocumentEntity.deleteItem(with: identifier, context: mainContext)
        mainContext.cd_saveToPersistentStore()
    }

    func addOrUpdateDocument(from content: DocumentMetadataModel) {
        DocumentEntity.addOrUpdateDocument(from: content, context: mainContext)
        mainContext.cd_saveToPersistentStore()
    }
}
