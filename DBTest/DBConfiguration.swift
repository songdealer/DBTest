//
//  DBConfiguration.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation

enum DBConfiguration {
    enum DBError: Error {
        case filePathError
        case openError
        
        case migrationError
        case invalidDataError
    }
}
