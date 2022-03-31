//
//  StorageDataRepositoryImpl.swift
//  DataAccess
//
//  Created by Amjadi on 2022. 03. 31..
//

import Foundation
import CoreData

class StorageDataRepositoryImpl: StorageDataRepository {

    private var mainContext: NSManagedObjectContext!

    init() {
        let container = NSPersistentContainer.create(for: "FileConverterUIConcept")
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = container.viewContext
    }

    func loadConvertedModels() -> [DocumentMetadataModel] {
        return DocumentEntity.getItems(in: mainContext)?.compactMap({
            DocumentMetadataModel(from: $0)
        }) ?? []
    }

    func deleteDocument(with identifier: Int, removedCellIndex: Int) {
        DocumentEntity.deleteItem(with: identifier, context: mainContext)
        mainContext.cd_saveToPersistentStore()
    }

    func addOrUpdateDocument(from content: DocumentMetadataModel) {
        DocumentEntity.addOrUpdateDocument(from: content, context: mainContext)
        mainContext.cd_saveToPersistentStore()
    }
}
