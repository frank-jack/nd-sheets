//
//  LabelView.swift
//  nD Sheets
//
//  Created by Jack Frank on 2/3/23.
//

import SwiftUI

struct LabelView: View {
    @EnvironmentObject var modelData: ModelData
    @State var label: Int
    @State var row: Bool
    //@State var showResize = false
    //@State var size = ""
    var body: some View {
        if row {
            Text(String(label))
                .frame(width: 40, height: 21)
                .border(.black.opacity(0.4))
                .background(.black.opacity(0.1))
                .contextMenu {
                    Button("Add Row Before") {
                        modelData.addLine(spot: label, dim1: modelData.dim1, dim2: modelData.dim2)
                    }
                    Button("Add Row After") {
                        modelData.addLine(spot: label+1, dim1: modelData.dim1, dim2: modelData.dim2)
                    }
                    Button("Delete Row") {
                        modelData.deleteLine(spot: label, dim1: modelData.dim1, dim2: modelData.dim2)
                    }
                    /*Button("Resize Row") {
                        showResize = true
                    }*/
                }
                /*.alert("Resize Row", isPresented: $showResize, actions: {
                    TextField("TextField", text: $size)
                    Button("Submit", action: {})
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Enter Row Size")
                })*/
        } else {
            Text(String(label))
                .frame(width: 120, height: 21)
                .border(.black.opacity(0.4))
                .background(.black.opacity(0.1))
                .contextMenu {
                    Button("Add Column Before") {
                        modelData.addLine(spot: label, dim1: modelData.dim2, dim2: modelData.dim1)
                    }
                    Button("Add Column After") {
                        modelData.addLine(spot: label+1, dim1: modelData.dim2, dim2: modelData.dim1)
                    }
                    Button("Delete Column") {
                        modelData.deleteLine(spot: label, dim1: modelData.dim2, dim2: modelData.dim1)
                    }
                    /*Button("Resize Column") {
                        showResize = true
                    }*/
                }
                /*.alert("Resize Column", isPresented: $showResize, actions: {
                    TextField("TextField", text: $size)
                    Button("Submit", action: {})
                    Button("Cancel", role: .cancel, action: {})
                }, message: {
                    Text("Enter Column Size")
                })*/
        }
    }
}
