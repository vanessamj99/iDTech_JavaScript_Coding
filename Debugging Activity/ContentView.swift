//
//  ContentView.swift
//  Memory Game
//
//  Created by Vanessa Johnson zxc 
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    @State var selectedNum : Int
    var body: some View {
        VStack{
            HStack{
                Text("Choose Size").bold().foregroundColor(.orange)
                Picker("", selection: $selectedNum){
                    Text("6 Pairs").tag(6)
                    Text("8 Pairs").tag(8)
                    Text("10 Pairs").tag(10)
                }.pickerStyle(.menu).foregroundColor(.teal).tint(.orange).border(.orange)
                Button("Reset Game"){
                    viewModel.resetGame()
                }
                .padding().buttonStyle(.borderedProminent).tint(.orange)
            }
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
        }.onChange(of: selectedNum) { oldValue, newValue in
            viewModel.chooseSize(selectedNum: newValue)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 130),spacing: 0)], spacing: 0){
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(3)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }.foregroundColor(.teal)
            .padding()
    }
}


struct CardView: View {
    
    let card: GameModel<String>.Card
    
    init(_ card: GameModel<String>.Card) {
        self.card = card
    }
    var body: some View {
        let rectangleBase: RoundedRectangle = RoundedRectangle(cornerRadius: 30)
        ZStack {
            Group {
                rectangleBase
                    .foregroundColor(.white)
                rectangleBase
                    .strokeBorder(lineWidth: 4)
                Text(card.content).font(.system(size: 80))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1,contentMode: .fit)
            }.opacity(card.isFaceUp ? 1: 0)
            rectangleBase.opacity(card.isFaceUp ? 0: 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}






#Preview {
    ContentView(viewModel: MemoryGameViewModel(selectedNum: 6), selectedNum: 6)
}

