//
//  ContentView.swift
//  DBTest
//
//  Created by user on 2/7/26.
//

import SwiftUI

extension ContentView {
    // TEXT TO INT
    private func textToInt(_ text: String) -> Int {
        if let ret = Int(text) {
            return ret
        }
        return 0
    }
}

// MARK: - UI
struct ContentView: View {
    
    // insert
    @State var nameText: String = ""
    @State var ageText: String = ""
    
    // update
    @State var updateIdText: String = ""
    @State var updateNameText: String = ""
    @State var updateAgeText: String = ""
    
    // delete
    @State var deleteIdText: String = ""
    
    var body: some View {
        VStack {
            titleView
            Divider()
            createUserTableView
            Divider()
            insertUserTableView
            Divider()
            readUserTableView
            Divider()
            updateUserTableView
            Divider()
            deleteUserTableView
            Divider()
        }
        .padding()
    }
    
    // MARK: - SubView
    @ViewBuilder
    var titleView: some View {
        Text("SQLite3 TEST")
            .font(.system(size: 56, weight: .bold))
        Spacer()
            .frame(height: 60)
    }
    
    @ViewBuilder
    var createUserTableView: some View {
        Button(
            action: {
                SQLiteManager.shared.createTable(tableName: "User", columns: User.columns)
            },
            label: {
                Text("User Table 생성")
            })
    }
    
    @ViewBuilder
    var insertUserTableView: some View {
        TextField(text: $nameText, label: {
            Text("User Name")
        })
        TextField(text: $ageText, label: {
            Text("User Age")
        })
        Button(
            action: {
                SQLiteManager.shared.insertDataUser(
                    tableName: "User",
                    values: [
                        .init(columnName: "name", value: nameText, isText: true),
                        .init(columnName: "age", value: "\(textToInt(ageText))", isText: false)
                    ])
                //GRDBManager.shared.insertDataUser(user: User(name: nameText, age: UInt8(textToInt(ageText))))
                nameText = ""
                ageText = ""
            },
            label: {
                Text("User Data 삽입")
            })
    }
    
    @ViewBuilder
    var readUserTableView: some View {
        Button(
            action: {
                let result = SQLiteManager.shared.readDataUser()
                //let result = GRDBManager.shared.readDataUser()
                print("result: \(result)")
            },
            label: {
                Text("User Data 읽기")
            })
    }
    
    @ViewBuilder
    var updateUserTableView: some View {
        TextField(text: $updateIdText, label: {
            Text("User Id")
        })
        TextField(text: $updateNameText, label: {
            Text("User Name")
        })
        TextField(text: $updateAgeText, label: {
            Text("User Age")
        })
        
        Button(action: {
            let user = User(id: UInt64(textToInt(updateIdText)), name: updateNameText, age: UInt8(textToInt(updateAgeText)))
            SQLiteManager.shared.updateDataUser(user: user)
//            GRDBManager.shared.updateDataUser(user: user)
            updateIdText = ""
            updateNameText = ""
            updateAgeText = ""
        },
               label: {
            Text("User Data 수정")
        })
    }
    
    @ViewBuilder
    var deleteUserTableView: some View {
        TextField(text: $deleteIdText, label: {
            Text("User Id")
        })
        
        Button(action: {
            SQLiteManager.shared.deleteDataUser(id: UInt64(textToInt(deleteIdText)))
            //GRDBManager.shared.deleteDataUser(id: UInt64(textToInt(deleteIdText)))
            deleteIdText = ""
        },
               label: {
            Text("User Data 삭제")
        })
    }
}

#Preview {
    ContentView()
}
