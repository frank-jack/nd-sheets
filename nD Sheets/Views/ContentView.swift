//
//  ContentView.swift
//  nD Sheets
//
//  Created by Jack Frank on 1/9/23.
//

import SwiftUI
import SimultaneouslyScrollView
import Introspect

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.scenePhase) private var scenePhase
    @State private var showSettings = false
    @State var searchText = ""
    var searchResults: [Sheet] {
        if searchText.isEmpty {
            return modelData.sheetList
        } else {
            return modelData.sheetList.filter { $0.title.contains(searchText) }
        }
    }
    init() {
        let appearance = UIToolbarAppearance()
        appearance.configureWithTransparentBackground()
        UIToolbar.appearance().standardAppearance = appearance
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ScrollView {
                    if modelData.sheetList.count-1 >= 0 {
                        ForEach(0...modelData.sheetList.count-1, id: \.self) { sheetId in
                            if searchResults.contains(modelData.sheetList[sheetId]) {
                                HStack {
                                    NavigationLink(destination: SheetView(), label: {
                                        HStack {
                                            Image("logo")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                            Text(modelData.sheetList[sheetId].title)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 18))
                                        .foregroundColor(.black.opacity(0.8))
                                        
                                    })
                                    .simultaneousGesture(TapGesture().onEnded {
                                        modelData.sheet = modelData.sheetList[sheetId].sheet
                                        modelData.sheetTitle = modelData.sheetList[sheetId].title
                                        modelData.size = modelData.sheetList[sheetId].size
                                        modelData.dim1 = modelData.sheetList[sheetId].dim1
                                        modelData.dim2 = modelData.sheetList[sheetId].dim2
                                        modelData.sheetId = sheetId
                                        modelData.initCall()
                                    })
                                    Menu {
                                        Button(action: {
                                            let sheet = Sheet(sheet: modelData.sheetList[sheetId].sheet, title: "Copy of "+modelData.sheetList[sheetId].title, size: modelData.sheetList[sheetId].size, dim1: modelData.sheetList[sheetId].dim1, dim2: modelData.sheetList[sheetId].dim2)
                                            modelData.sheetList.append(sheet)
                                        }, label: {
                                            Label("Make a copy", systemImage: "doc.on.doc")
                                        })
                                        Button(role: .destructive, action: {
                                            modelData.sheetList.remove(at: sheetId)
                                        }, label: {
                                            Label("Delete", systemImage: "trash")
                                        })
                                    } label: {
                                        Label("", systemImage: "ellipsis")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        SheetView()
                    } label: {
                        Text("+")
                          .font(.system(size: 50))
                          .foregroundColor(Color("Green"))
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        let sheet = Sheet(sheet: [Cell](), title: "Untitled Sheet", size: [35, 5, 5], dim1: 0, dim2: 1)
                        modelData.sheetList.append(sheet)
                        modelData.sheet = sheet.sheet
                        modelData.sheetTitle = sheet.title
                        modelData.size = sheet.size
                        modelData.dim1 = sheet.dim1
                        modelData.dim2 = sheet.dim2
                        modelData.sheetId = modelData.sheetList.count-1
                        modelData.initCall()
                    })
                }
                /*ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }*/
            }
            .sheet(isPresented: $showSettings) {
                Settings()
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive {
                    ModelData.save(sheetList: modelData.sheetList) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear() { //temp
            /*for i in 1...30 {
                modelData.sheetList.append(Sheet(sheet: [Cell](), title: "Sheet "+String(i), size: [35, 5, 5], dim1: 0, dim2: 1))
            }*/
        }
    }
}
