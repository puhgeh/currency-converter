//
//  Cards.swift
//  CurrencyConverter
//
//  Created by Axel on 8/8/22.
//

import SwiftUI

struct Cards: View {
    @EnvironmentObject private var viewModel: CurrencyViewModel
    private let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            ForEach(viewModel.cards.indices.reversed(), id: \.self) { index in
                HStack {
                    // simple sample card. real world app will be actual card with gradient and icons
                    CardView(card: viewModel.cards[index])
                        .frame(width: cardWidth(index: index), height: cardHeight(index: index))
                        .shadow(radius: 5)
                        .offset(x: cardOffset(index: index))
                        .rotationEffect(.init(degrees: cardRotation(index: index)))
                    
                    Spacer(minLength: 0)
                }
                .frame(height: 200)
                .contentShape(Rectangle())
                .offset(x: viewModel.cards[index].offset)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        onChanged(value: value, index: index)
                    }).onEnded({ value in
                        onEnd(value: value, index: index)
                    }))
            }
        }
        .padding(.top, 25)
        .padding(.horizontal, 30)
    }
    
    func cardHeight(index: Int) -> CGFloat {
        let height = 200.0
        let cardHeight = index - viewModel.swipedCard <= 2 ? CGFloat(index) * 15 : 70
        
        return height - cardHeight;
    }
    
    func cardWidth(index: Int) -> CGFloat {
        let boxWidth = UIScreen.main.bounds.width - 100
        return boxWidth;
    }
    
    func cardOffset(index: Int) -> CGFloat {
        return index <= 2 ? CGFloat(index - viewModel.swipedCard) * 25 : 60
    }
    
    func cardRotation(index: Int) -> Double {
        let boxWidth = Double(width / 3)
        let offset = Double(viewModel.cards[index].offset)
        let angle = 5.0
        
        return offset / boxWidth * angle
    }
    
    func onChanged(value: DragGesture.Value, index: Int) {
        if value.translation.width < 0 {
            viewModel.cards[index].offset = value.translation.width
        }
    }
    
    func onEnd(value: DragGesture.Value, index: Int) {
        withAnimation {
            if -value.translation.width > width / 3 {
                viewModel.cards[index].offset = -width
                viewModel.swipedCard += 1
            } else {
                viewModel.cards[index].offset = 0
            }
        }
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        Cards()
            .environmentObject(CurrencyViewModel.shared)
    }
}

