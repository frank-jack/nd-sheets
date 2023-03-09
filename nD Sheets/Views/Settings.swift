//
//  Settings.swift
//  nD Sheets
//
//  Created by Jack Frank on 2/6/23.
//

import SwiftUI
import Setting

struct Settings: View {
    @EnvironmentObject var modelData: ModelData
    @AppStorage("isOn") var isOn = true
    var body: some View {
        SettingStack {
            SettingPage(title: "Playground") {
                SettingGroup(header: "Main Group") {
                    SettingToggle(title: "This value is persisted!", isOn: $isOn)
                    SettingCustomView {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160)
                            .padding(20)
                    }
                    SettingPage(title: "Advanced Settings") {
                        SettingText(title: "I show up on the next page!")
                    }
                }
            }
        }
    }
}
