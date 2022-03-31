//
//  DocumentMetadataModel.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 26..
//

import Foundation

public struct DocumentMetadataModel {

    var uniqueIdentifier: Int
    var fileURL: URL?
    var localizedName: String?
    var fileType: String?
    var fileModificationDate: Date?
    var data: Data?

    init(uniqueIdentifier: Int,
         fileURL: URL?,
         localizedName: String?,
         fileType: String?,
         fileModificationDate: Date?,
         data: Data?) {

        self.uniqueIdentifier = uniqueIdentifier
        self.fileURL = fileURL
        self.localizedName = localizedName
        self.fileType = fileType
        self.fileModificationDate = fileModificationDate
        self.data = data
    }

    init(from entity: DocumentEntity) {

        uniqueIdentifier = Int(entity.identifier)
        fileURL = entity.fileURL
        localizedName = entity.name
        fileType = entity.fileType
        fileModificationDate = entity.modificationDate
        data = entity.fileData
    }
}
