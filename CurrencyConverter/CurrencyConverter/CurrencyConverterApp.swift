//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CurrencyViewModel.shared)
        }
    }
}
