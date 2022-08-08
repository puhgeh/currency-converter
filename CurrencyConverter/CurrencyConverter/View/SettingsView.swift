//
//  SettingsView.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

// This exist only for this sample app for convenience
struct SettingsView: View {
    @EnvironmentObject private var viewModel: CurrencyViewModel
    
    var body: some View {
        
        Form {
            HStack {
                Text("Commision Fee %: ")
                
                Spacer()
                
                TextField("%", value: $viewModel.settings.commissionFee, formatter: viewModel.numberFormatter).keyboardType(.decimalPad)
                    .fixedSize()
            }
            
            HStack {
                Text("Min Free Conversion: ")
                
                Spacer()
                
                TextField("", value: $viewModel.settings.minFreeConversion, format: .number)
                    .keyboardType(.numberPad)
                    .fixedSize()
            }
            
            HStack {
                Text("Avail. Free Conversions: ")
                
                Spacer()
                
                TextField("", value: $viewModel.settings.availFreeConversions, format: .number)
                    .keyboardType(.numberPad)
                    .fixedSize()
            }
        }
        .navigationTitle("Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(CurrencyViewModel.shared)
    }
}
