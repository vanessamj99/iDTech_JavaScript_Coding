//
//  GameModel.swift
//  Memory Game
//
//  Created by Vanessa Johnson on 3/23/24.
//

import Foundation

struct GameModel<CardInfo> where CardInfo: Equatable {

    private(set) var cards: Array<Card>

    init(numberOfPairsOfCards: Int, CardInfoFactory: (Int) -> CardInfo){
        cards = Array<Card>()
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content: CardInfo = CardInfoFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get{
            return cards.indices.filter{ index in cards[index].isFaceUp }.only
        }
        set{
            cards.indices.forEach {
                cards[$0].isFaceUp = (newValue == $0)
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}){
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                    else{
                        cards[chosenIndex].isFaceUp = false
                        cards[potentialMatchIndex].isFaceUp = false
                        cards[chosenIndex].isMatched = false
                        cards[potentialMatchIndex].isMatched = false
                    }
                }
                else{
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
            
        }
    }
    
    mutating func resetGame(){
        for(index, _ ) in cards.enumerated() {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
        cards.shuffle()
    }
    
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardInfo
        
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up": "down")\(isMatched ? " Matched": "")"
        }
    }
}



extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
