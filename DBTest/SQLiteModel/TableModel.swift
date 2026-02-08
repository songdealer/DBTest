//
//  TableModel.swift
//  DBTest
//
//  Created by user on 2/8/26.
//

import Foundation
import SQLite3

protocol TableModel {
    static var columns: [Column] { get }
}
