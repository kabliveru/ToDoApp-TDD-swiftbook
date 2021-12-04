//  Created by Алексей Королев

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
        case let .sectionOutOfRange(section):
            return NSLocalizedString("section \(section) out of range", comment: "")
        }
    }
}
