//
//  ConversionView.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

struct ConversionView: View {
    @EnvironmentObject private var viewModel: CurrencyViewModel
    @State private var canConvert = false
    @State private var showDialog = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrow.up")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(.red)
                    .clipShape(Circle())
                
                Text("Sell")
                
                Spacer()
                
                CurrencyTextField(numberFormatter: viewModel.currencyFormatter, currencyCode: $viewModel.baseCurrency, value: $viewModel.baseAmount)
                
                Text(viewModel.baseCurrency)
                    .frame(width: 40)
                
                Menu {
                    Picker(selection: $viewModel.baseCurrency, label: Text("Currency")) {
                        ForEach(viewModel.availableCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                }
                label: {
                    Label("", systemImage: "arrowtriangle.down")
                        .foregroundColor(.black)
                }
                
            }
            .padding()
            
            HStack {
                Image(systemName: "arrow.down")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(.green)
                    .clipShape(Circle())
                
                Text("Receive")
                
                Spacer()
                
                Text(viewModel.quoteAmount, format: .currency(code: viewModel.quoteCurrency))
                    .font(.system(size: 30, weight: .regular))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .onChange(of: viewModel.quoteAmount) { value in
                        withAnimation {
                            canConvert = value > 0
                        }
                    }
                
                Text(viewModel.quoteCurrency)
                    .frame(width: 40)
                
                Menu {
                    Picker(selection: $viewModel.quoteCurrency, label: Text("Currency")) {
                        ForEach(viewModel.availableConversions, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                }
                label: {
                    Label("", systemImage: "arrowtriangle.down")
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            if canConvert {
                Button {
                    viewModel.applyConversion()
                    showDialog.toggle()
                } label: {
                    Text("Submit")
                }
                .frame(width: 120)
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .cornerRadius(20)
                .padding(.top, 50)
                .shadow(radius: 5)
                .alert(viewModel.title, isPresented: $viewModel.showMessage) {
                    Button {
                        viewModel.showMessage = false
                    } label: {
                        Text("Done")
                    }
                } message: {
                    Text(viewModel.message)
                }

            }
        }
    }
}

struct ConversionView_Previews: PreviewProvider {
    static var previews: some View {
        ConversionView()
            .environmentObject(CurrencyViewModel.shared)
    }
}
