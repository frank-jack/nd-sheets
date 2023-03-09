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
    var body: some View {
        /*TextField("", text: $text, axis: .vertical)
            .frame(width: 120, height: 21)
            .border(.black.opacity(0.4))*/
        Button(action: {
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
    }
}
