//
//  CurrencyTextField.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import Foundation
import SwiftUI

struct CurrencyTextField: UIViewRepresentable {
    @Binding var currencyCode: String
    
    typealias UIViewType = CurrencyUITextField
    
    let currencyField: CurrencyUITextField
    
    init(numberFormatter: NumberFormatter, currencyCode: Binding<String>, value: Binding<Decimal>) {
        self._currencyCode = currencyCode
        let currencyFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: currencyFormatter, value: value)
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) {
        uiView.updateCurrencyCode(code: currencyCode)
    }
}
