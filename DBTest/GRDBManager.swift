//
//  GRDBManager.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation
import GRDB

class GRDBManager {
    static let shared = GRDBManager()
    var dbQueue: DatabaseQueue? = nil
    
    private init() {
        dbQueue = try? GRDBManager.createDBQueue()
    }
    
    private static func createDBQueue() throws -> DatabaseQueue {
        guard let filePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(SQLiteManager.databaseName).path, let dbQueue = try? DatabaseQueue(path: filePath) else { throw DBConfiguration.DBError.filePathError }
        
        return dbQueue
    }
    
    private func migration() throws {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("AddUserV1") { db in
            try db.create(table: "User") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("name", .text).notNull()
                table.column("age", .integer).notNull()
            }
        }
        
        guard let dbQueue = dbQueue else { throw DBConfiguration.DBError.migrationError }
        
        try migrator.migrate(dbQueue)
    }
    
    func insertDataUser(user: User) {
        try? GRDBManager.shared.dbQueue?.write { db in
            try? user.insert(db)
        }
    }
    
    func readDataUser() -> [User] {
        let users = try? GRDBManager.shared.dbQueue?.read { db in
            try? User.fetchAll(db)
        }
        return users ?? []
    }
    
    func updateDataUser(user: User) {
        try? GRDBManager.shared.dbQueue?.write { db in
            guard let id = user.id else { throw DBConfiguration.DBError.invalidDataError }
            guard var newUser = try? User.fetchOne(db, key: id) else { throw DBConfiguration.DBError.invalidDataError }
            
            newUser.name = user.name
            newUser.age = user.age
            
            try? user.update(db)
        }
    }
    
    func deleteDataUser(id: UInt64) {
        try? GRDBManager.shared.dbQueue?.write { db in
            try? User.deleteOne(db, key: id)
        }
    }
    
}
