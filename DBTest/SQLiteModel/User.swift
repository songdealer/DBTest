//
//  User.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation
import SQLite3
import GRDB

public struct User: TableModel, Codable, FetchableRecord, PersistableRecord {
    var id: UInt64?
    var name: String
    var age: UInt8
    
    static var columns: [Column] {
        return [
            .init(name: "name", type: .TEXT),
            .init(name: "age", type: .INTEGER)
        ]
    }
}
