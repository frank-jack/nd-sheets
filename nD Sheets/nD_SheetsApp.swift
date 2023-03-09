//
//  nD_SheetsApp.swift
//  nD Sheets
//
//  Created by Jack Frank on 1/9/23.
//

import SwiftUI

@main
struct nD_SheetsApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(modelData)
            .onAppear {
                ModelData.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let sheetList):
                        modelData.sheetList = sheetList
                    }
                }
            }
        }
    }
}
