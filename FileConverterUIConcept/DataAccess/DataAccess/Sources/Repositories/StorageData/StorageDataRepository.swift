//
//  StorageDataRepository.swift
//  DataAccess
//
//  Created by Amjadi on 2022. 03. 31..
//

import Foundation

public protocol StorageDataRepository {

    func loadConvertedModels() -> [DocumentMetadataModel]
    func deleteDocument(with identifier: Int, removedCellIndex: Int)
    func addOrUpdateDocument(from content: DocumentMetadataModel)
}
