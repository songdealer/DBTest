//
//  SQLiteManager.swift
//  DBTest
//
//  Created by user on 2/7/26.
//

import SQLite3
import Foundation

extension SQLiteManager {
    struct Value {
        let columnName: String
        let value: String
        let isText: Bool
    }
}

class SQLiteManager {
    static let databaseName: String = "database.DBTest"
    static let shared = SQLiteManager()
    
    private var db: OpaquePointer? = nil
    
    init() {
        self.db = try? SQLiteManager.createDB()
    }
}

extension SQLiteManager {
    private func logErrorMessage() {
        guard let db = self.db else { return }
        
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("errorMessage: \(errorMessage)")
    }
    private static func createDB() throws -> OpaquePointer {
        //파일 경로
        guard let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(databaseName).path else { throw DBConfiguration.DBError.filePathError }
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath, &db) != SQLITE_OK {
            throw DBConfiguration.DBError.openError
        } else {
            return db!
        }
    }

    func createTable(tableName: String, columns: [Column]) {
        
        let column: String = {
            var str = "id INTEGER PRIMARY KEY AUTOINCREMENT"
            for col in columns {
                let notNull = col.isNull ? "" : " NOT NULL"
                str += ", \(col.name) \(col.type.rawValue)\(notNull)"
            }
            // FOREIGN KEY \(col.name) REFERENCES \(ref.tableName)\(ref.columnName)
            return str
        }()
        
        let query = "CREATE TABLE IF NOT EXISTS" + " \(tableName)" + "(\(column));"
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &createTable, nil) == SQLITE_OK { // Create Table SQL 준비
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("Table Creation Success")
                // Table Creation Success
            } else {
                print("Table Creation Fail")
                logErrorMessage()
            }
        } else {
            print("Preparation Fail")
            logErrorMessage()
        }
        sqlite3_finalize(createTable)
    }
    
    func dropTable(tableName: String) {
        let query = "DROP TABLE \(tableName);"
        var dropTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &dropTable, nil) == SQLITE_OK { // Create Table SQL 준비
            if sqlite3_step(dropTable) == SQLITE_DONE {
                print("Table Drop Success")
                // Table Drop Success
            } else {
                print("Table Drop Fail")
                logErrorMessage()
            }
        } else {
            print("Preparation Fail")
            logErrorMessage()
        }
        sqlite3_finalize(dropTable)
        
    }
    
    func insertDataUser(tableName: String, values: [Value]) {
        let column: String = values.map { $0.columnName }.joined(separator: ", ")
        let value: String = values.map { $0.isText ? "'\($0.value)'" : $0.value }.joined(separator: ", ")
            
        let insertQuery = "insert into \(tableName) (\(column)) values (\(value));"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data Insertion Success")
            } else {
                print("Data Insertion Fail")
                logErrorMessage()
            }
        } else {
            print("Preparation Fail")
            logErrorMessage()
        }
    }
    
    func readDataUser() -> [User] {
        let query: String = "select * from User;"
        var statement: OpaquePointer? = nil
        
        var result: [User] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            logErrorMessage()
            return []
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            guard let namePointer = sqlite3_column_text(statement, Int32(1)) else { return [] }
            let name = String(cString: namePointer)
            let age = sqlite3_column_int(statement, Int32(2))
            
            let data = User(id: UInt64(id), name: name, age: UInt8(age))
            result.append(data)
        }
        sqlite3_finalize(statement)
        
        return result
    }
    func updateDataUser(user: User) {
        var statement: OpaquePointer? = nil
        let query = "UPDATE User SET name='\(user.name)',age=\(user.age) WHERE id=\(user.id);"
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK {
            logErrorMessage()
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            logErrorMessage()
            return
        }
        
        print("Data Update Success")
    }
    
    func deleteDataUser(id: UInt64) {
        let query = "delete from User where id = \(id)"
        
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Delete Success")
            } else {
                print("Delete Fail")
            }
        } else {
            print("Preparation Fail")
        }
        sqlite3_finalize(statement)
    }
}
