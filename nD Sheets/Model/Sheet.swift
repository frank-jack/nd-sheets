//
//  Sheet.swift
//  nD Sheets
//
//  Created by Jack Frank on 2/22/23.
//

import Foundation

struct Sheet: Hashable, Codable {
    var sheet: [Cell]
    var title: String
    var size: [Int]
    var dim1: Int
    var dim2: Int
    
    static let `default` = Sheet(sheet: [Cell](), title: "Untitled Sheet", size: [35, 5, 5], dim1: 0, dim2: 1)
}
