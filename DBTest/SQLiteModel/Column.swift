//
//  Column.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation
import SQLite3

struct Column {
    let name: String
    let type: SQLiteType
    let isNull: Bool = false
}
