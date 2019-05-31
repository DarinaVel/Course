//
//  Concentration.swift
//  Concetration
//
//  Created by Кирилл Смирнов on 25/02/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import Foundation

extension Collection {
    var oneAndOnly: Element? {
        return self.count == 1 ? self.first : nil
    }
}

class Concentration {
    
    private(set) var cards = [Card]()
    private var usingCards = [Int]()
    private(set) var score = 0
    private(set) var count = 0
    private var timeLastStep: Date = Date()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return self.cards.indices.filter {self.cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in self.cards.indices {
                self.cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        
        assert(self.cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): выбранный индекс не совпадает с картами")
        
        //Если уже не совпавшие
        if !self.cards[index].isMatched {
            
            if !self.cards[index].isFaceUp {
                self.count += 1
            }
            //Если есть предыдущи индекс и он не равен новому
            if let matchIndex = self.indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //Если индексы перевернутой и текущей совпадают, матчим их
                if self.cards[matchIndex].identifier == self.cards[index].identifier {
                    self.cards[matchIndex].isMatched = true
                    self.cards[index].isMatched = true
                    let difference = timeLastStep.timeIntervalSinceNow
                    print(difference)
                    var koef = 0
                    if (difference >= -9 && difference <= 0){
                        koef = 3
                    }
                    else if(difference >= -19 && difference <= -10){
                        koef = 2
                    }
                    else{
                        koef = 1
                    }
                    self.score += koef
                }
                else{
                    if self.usingCards.contains(self.cards[matchIndex].identifier){
                        self.score -= 1
                    }
                    else{
                        self.usingCards+=[self.cards[matchIndex].identifier]
                    }
                    if !self.usingCards.contains(self.cards[index].identifier){
                        self.usingCards+=[self.cards[index].identifier]
                    }
                }
                //Текущую переварачиваем
                self.cards[index].isFaceUp = true
                
            } else {
                self.indexOfOneAndOnlyFaceUpCard = index
            }
            timeLastStep = Date()
        }

    }
    
    init(numberOfPairsCard: Int) {
        
        assert(numberOfPairsCard > 0, "Количество пар карт, должно быть больше 0")
        
        for _ in 0..<numberOfPairsCard {
            let card = Card()
            self.cards += [card, card]
        }
        cards = cards.shuffled()
    }
    
}
