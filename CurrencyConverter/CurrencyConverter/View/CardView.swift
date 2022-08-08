//
//  CardView.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Balance")
                .padding(.top, 20)
            Text(card.balance, format: .currency(code: card.currency))
                .font(.largeTitle)
            
            Spacer()
            
            Text(card.number)
                .font(.title)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .background(card.color)
        .cornerRadius(10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: CurrencyViewModel.shared.cards[0])
    }
}
