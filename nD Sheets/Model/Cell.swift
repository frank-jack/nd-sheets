//
//  Cell.swift
//  nD Sheets
//
//  Created by Jack Frank on 1/9/23.
//

import Foundation

struct Cell: Hashable, Identifiable, Codable {
    var id: Int
    var text: String
    var pos: [Int]
    
    static let `default` = Cell(id: -1, text: "Bad Cell", pos: [-1,-1])
}
