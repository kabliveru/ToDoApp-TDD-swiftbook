//
//  String+Ext.swift
//  ToDoApp
//
//  Created by Алексей Королев on 05.12.2021.
//

import Foundation

extension String {
    var percentEncoded : String? {
        let allowedCharacters = CharacterSet(charactersIn: "!@#$%^&*()-+=[]\\{},./?").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        return encodedString
    }
}
