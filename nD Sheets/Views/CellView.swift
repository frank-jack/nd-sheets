//
//  CellView.swift
//  nD Sheets
//
//  Created by Jack Frank on 1/9/23.
//

import SwiftUI

struct CellView: View {
    @EnvironmentObject var modelData: ModelData
    @State var cell: Cell
    @State var row: Int
    @State var col: Int
    @State private var text = ""
    @State private var borderColor = Color.black.opacity(0.4)
    @State private var borderWidth = 1
    //@State private var showTextEditor = true //iOS 16.4 needed
    var body: some View {
        /*TextField("", text: $text, axis: .vertical)
            .frame(width: 120, height: 21)
            .border(.black.opacity(0.4))*/
        /*Button(action: {
            if modelData.idHighlighted != cell.id {
                borderColor = .blue
                borderWidth = 3
                modelData.idHighlighted = cell.id
            } else {
                borderColor = .black.opacity(0.4)
                borderWidth = 1
                modelData.idHighlighted = -1
            }
        }) {
            TextField("", text: $text, axis: .vertical)
                .disabled(true)
                .multilineTextAlignment(.leading)
                .contentShape(Rectangle())
                .frame(width: 120, height: 21)
                .border(borderColor, width: CGFloat(borderWidth))
                .foregroundColor(.black)
        }*/
        ZStack {
            if modelData.idHighlighted != cell.id {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 120, height: 21)
                        .border(borderColor, width: CGFloat(borderWidth))
                    TextField("", text: $text, axis: .vertical)
                        .disabled(true)
                        .multilineTextAlignment(.leading)
                }
                .onTapGesture {
                    if modelData.idHighlighted != cell.id {
                        borderColor = .blue
                        borderWidth = 3
                        modelData.idHighlighted = cell.id
                    }
                }
            } else {
                Menu {
                    if modelData.idHighlighted == cell.id {
                        Button("Copy") {
                            UIPasteboard.general.setValue(text, forPasteboardType: "public.plain-text")
                        }
                        Button("Paste") {
                            text = UIPasteboard.general.string ?? ""
                        }
                        Button("Cut") {
                            UIPasteboard.general.setValue(text, forPasteboardType: "public.plain-text")
                            text = ""
                            cell.text = ""
                        }
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 120, height: 21)
                            .border(borderColor, width: CGFloat(borderWidth))
                        TextField("", text: $text, axis: .vertical)
                            .disabled(true)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .onChange(of: modelData.idHighlighted) { newValue in
            if modelData.idHighlighted != cell.id && borderWidth == 3 {
                borderColor = .black.opacity(0.4)
                borderWidth = 1
            }
        }
        /*.onChange(of: text) { newText in
            //print(cell.text)
            modelData.sheet[cell.id].text = newText
        }*/
        .onAppear() {
            text = cell.text
        }
        .contextMenu {
            Text(cell.pos.description)
        }
        .onChange(of: modelData.dim1) { newValue in
            cell = modelData.getCell(pos: modelData.getPos(row: row, col: col))
            text = cell.text
        }
        .onChange(of: modelData.dim2) { newValue in
            cell = modelData.getCell(pos: modelData.getPos(row: row, col: col))
            text = cell.text
        }
        .onChange(of: modelData.dimsHiddenValues) { newValue in
            cell = modelData.getCell(pos: modelData.getPos(row: row, col: col))
            text = cell.text
        }
        .onChange(of: modelData.sheet) { newValue in
            cell = modelData.getCell(pos: modelData.getPos(row: row, col: col))
            text = cell.text
        }
        /*.sheet(isPresented: $showTextEditor) {
            //Put text editor here at iOS 16.4
            .presentationDetents([.height(20)])
            .presentationBackgroundInteraction(.enabled) //Needs iOS 16.4 to work
        }*/
    }
}
