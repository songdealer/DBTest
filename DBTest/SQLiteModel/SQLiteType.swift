//
//  SQLiteType.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation
import SQLite3

enum SQLiteType: String {
    case TEXT = "TEXT" // 19~25 bytes
    case INTEGER = "INTEGER" // 1~4 bytes
    case REAL = "REAL" // 4 bytes
    case BLOB = "BLOB" // < 1MB로 설정을 권장
}
