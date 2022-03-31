//
//  Document.swift
//  FileConverterUIConcept
//
//  Created by Amjadi on 2020. 10. 25..
//

import UIKit

public class Document: UIDocument {

    var data: Data?
    var error: Error?

    public override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }

        return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    }

    public override func load(fromContents contents: Any, ofType typeName: String?) throws {

        guard let data = contents as? Data else {
            return
        }

        self.data = data
    }

    public override func handleError(_ error: Error, userInteractionPermitted: Bool) {
        // Save the error in case we need to pass it on (thumbnail extension)
        self.error = error

        // Call super to handle the error
        super.handleError(error, userInteractionPermitted: userInteractionPermitted)
    }
}
