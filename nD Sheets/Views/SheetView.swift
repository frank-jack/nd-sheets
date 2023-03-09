//
//  SheetView.swift
//  nD Sheets
//
//  Created by Jack Frank on 2/15/23.
//

import SwiftUI
import SimultaneouslyScrollView
import Introspect

struct SheetView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) private var scenePhase
    @State private var showLoading = true
    @State private var showHiddenDimChanger = false
    @State var text = ""
    @State private var listOfDims = [String]()
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var title = ""
    var simultaneouslyScrollViewHandlerHor = SimultaneouslyScrollViewHandlerFactory.create()
    var simultaneouslyScrollViewHandlerVert = SimultaneouslyScrollViewHandlerFactory.create()
    init() {
        UIScrollView.appearance().bounces = false
    }
    var body: some View {
        NavigationStack {
            if showLoading {
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 400, height: 400)
                    LottieView(lottieFile: "Loading")
                        .frame(width: 400, height: 400)
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showLoading = false
                    }
                }
            } else {
                VStack() {
                    HStack {
                        Button {
                            modelData.idHighlighted = -1
                            modelData.sheetList[modelData.sheetId].sheet = modelData.sheet
                            modelData.sheetList[modelData.sheetId].title = modelData.sheetTitle
                            modelData.sheetList[modelData.sheetId].size = modelData.size
                            modelData.sheetList[modelData.sheetId].dim1 = modelData.dim1
                            modelData.sheetList[modelData.sheetId].dim2 = modelData.dim2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Image("logo")
                                .resizable()
                                .frame(width: 65, height: 65)
                        }
                        VStack {
                            Spacer()
                                .frame(height: 10)
                            TextField("", text: $title)
                                .font(.system(size: 23))
                                .onAppear() {
                                    title = modelData.sheetTitle
                                }
                                .onChange(of: title) { newTitle in
                                    modelData.sheetTitle = newTitle
                                }
                        }
                    }
                    Spacer()
                        .frame(height: 5)
                    HStack {
                        /*Menu("File") {
                            
                        }*/
                        Menu("Edit") {
                            Picker("Choose Vertical Axis Dimension", selection: $text1) {
                                ForEach(listOfDims, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.menu)
                            Picker("Choose Horizontal Axis Dimension", selection: $text2) {
                                ForEach(listOfDims, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.menu)
                            if showHiddenDimChanger {
                                Button("Hide Dimension Editor") {
                                    showHiddenDimChanger = false
                                }
                            } else {
                                Button("Show Dimension Editor") {
                                    showHiddenDimChanger = true
                                    modelData.idHighlighted = -1
                                }
                            }
                        }
                        .onChange(of: text1) { newValue in
                            if text1 != text2 {
                                modelData.dim1 = Int(text1)!-1
                                modelData.dim2 = Int(text2)!-1
                                if modelData.n > 2 {
                                    modelData.setDimsHidden()
                                }
                            }
                        }
                        .onChange(of: text2) { newValue in
                            if text1 != text2 {
                                modelData.dim1 = Int(text1)!-1
                                modelData.dim2 = Int(text2)!-1
                                if modelData.n > 2 {
                                    modelData.setDimsHidden()
                                }
                            }
                        }
                        .onAppear() {
                            text1 = String(modelData.dim1+1)
                            text2 = String(modelData.dim2+1)
                            for i in 1...modelData.size.count {
                                listOfDims.append(String(i))
                            }
                        }
                        .onChange(of: modelData.n) { newValue in
                            text1 = String(modelData.dim1+1)
                            text2 = String(modelData.dim2+1)
                            listOfDims = [String]()
                            for i in 1...modelData.size.count {
                                listOfDims.append(String(i))
                            }
                        }
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 3)
                    Spacer()
                        .frame(height: 5)
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text(String(modelData.dim1+1)+"x"+String(modelData.dim2+1))
                                .frame(width: 40, height: 21)
                                .border(.black.opacity(0.4))
                                .background(.black.opacity(0.1))
                                .contextMenu {
                                    Text("Vertical Axis Dimension by Horizontal Axis Dimension")
                                }
                            ScrollView(.vertical) {
                                VStack(spacing: 0) {
                                    ForEach(modelData.labels[modelData.dim1], id: \.self) { rowLabel in
                                        LabelView(label: rowLabel, row: true)
                                    }
                                }
                            }
                            .introspectScrollView { simultaneouslyScrollViewHandlerVert.register(scrollView: $0) }
                        }
                        VStack(spacing: 0) {
                            ScrollView(.horizontal) {
                                HStack(spacing: 0) {
                                    ForEach(modelData.labels[modelData.dim2], id: \.self) { colLabel in
                                        LabelView(label: colLabel, row: false)
                                    }
                                }
                            }
                            .introspectScrollView { simultaneouslyScrollViewHandlerHor.register(scrollView: $0) }
                            ScrollView(.vertical) {
                                ScrollView(.horizontal) {
                                    Grid(verticalSpacing: 0) {
                                        ForEach(1...modelData.size[modelData.dim1], id: \.self) { row in
                                            HStack(spacing: 0) {
                                                ForEach(1...modelData.size[modelData.dim2], id: \.self) { col in
                                                    GridRow {
                                                        CellView(cell: modelData.getCell(pos: modelData.getPos(row: row, col: col)), row: row, col: col)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .introspectScrollView { simultaneouslyScrollViewHandlerHor.register(scrollView: $0) }
                            }
                            .introspectScrollView { simultaneouslyScrollViewHandlerVert.register(scrollView: $0) }
                        }
                    }
                    if modelData.idHighlighted != -1 {
                        TextField("Enter text...", text: $text)
                            .padding()
                            .onAppear() {
                                text = modelData.sheet[modelData.idHighlighted].text
                                showHiddenDimChanger = false
                            }
                            .onChange(of: text) { newText in
                                modelData.sheet[modelData.idHighlighted].text = newText
                            }
                            .onChange(of: modelData.idHighlighted) { newValue in
                                text = modelData.sheet[modelData.idHighlighted].text
                            }
                    }
                }
                .sheet(isPresented: $showHiddenDimChanger) {
                    ScrollView {
                        if modelData.dimsHidden.count > 0 {
                            ForEach(0...modelData.dimsHidden.count-1, id: \.self) { dimNum in
                                Text("Hidden Dimension: "+String(modelData.dimsHidden[dimNum]+1))
                                Slider(value: IntDoubleBinding($modelData.dimsHiddenValues[dimNum]).doubleValue, in: 1.0...Double(modelData.size[modelData.dimsHidden[dimNum]]), step: 1.0)
                                Text(String(modelData.dimsHiddenValues[dimNum]))
                            }
                        }
                        Button("Add Dimension") {
                            modelData.addDim()
                        }
                        if modelData.dimsHidden.count > 0 {
                            Divider()
                            Picker("Choose", selection: $text3) {
                                Text("Choose Dimension to Remove")
                                ForEach(listOfDims, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            Button("Remove Dimension") {
                                if Int(text3) ?? 0 != 0 {
                                    modelData.removeDim(dim: Int(text3)!-1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .presentationDetents([.height(200)])
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        modelData.idHighlighted = -1
                        modelData.sheetList[modelData.sheetId].sheet = modelData.sheet
                        modelData.sheetList[modelData.sheetId].title = modelData.sheetTitle
                        modelData.sheetList[modelData.sheetId].size = modelData.size
                        modelData.sheetList[modelData.sheetId].dim1 = modelData.dim1
                        modelData.sheetList[modelData.sheetId].dim2 = modelData.dim2
                        ModelData.save(sheetList: modelData.sheetList) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}
