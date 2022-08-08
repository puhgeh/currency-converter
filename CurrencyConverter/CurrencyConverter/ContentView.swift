//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: CurrencyViewModel
    @State private var canConvert = false;

    // In real world app, strings will be localized
    var body: some View {
        NavigationView{
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    Text("My Balances")
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    Cards()
                    
                    Text("Currency Exchange")
                        .padding()
                    
                    ConversionView()
                }

            }
            .onTapGesture(perform: dismissKeyboard)
            .navigationBarTitle("Currency Converter", displayMode: .inline)
            .navigationBarItems(leading: Button {
                resetCards()
            } label: {
                Image(systemName: "arrow.clockwise")
            },
            trailing: NavigationLink(destination: SettingsView(), label: {
                Image(systemName: "gear")
            }))
        }
    }
    
    fileprivate func resetCards() {
        withAnimation {
            viewModel.cards.indices.forEach { index in
                viewModel.cards[index].offset = 0
            }
            viewModel.swipedCard = 0
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CurrencyViewModel.shared)
    }
}
