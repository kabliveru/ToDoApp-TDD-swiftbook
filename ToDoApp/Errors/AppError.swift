//
//  AppError.swift
//  ToDoApp
//
//  Created by Алексей Королев on 01.12.2021.
//

import Foundation

enum AppError {
    case taskManagerIsNil
    case sectionOutOfRange(section: Int)
    
}

extension AppError: Error {
    var errorDescription: String {
        switch self {
        case .taskManagerIsNil:
            return NSLocalizedString("taskManager is nil", comment: "")
        case .sectionOutOfRange(let section):
            return NSLocalizedString("section \(section) out of range", comment: "")
        }
    }
}
