//
//  ViewController.swift
//  Concetration
//
//  Created by Кирилл Смирнов on 12/02/2019.
//  Copyright © 2019 asu. All rights reserved.
//

import UIKit

var themes = [["😀","😭","😱","😇","😛","😍","😎","🤓"],
              ["😈","👹","👺","🤡","👻","💀","👾","🎃"],
              ["👢","🧦","🧤","🧣","🌨","❄️","☃️","🎄"],
              ["💐","🌷","🌹","🥀","🌺","🌸","🌼","🌻"],
              ["🍏","🍐","🍊","🍋","🍌","🍍","🥝","🥑"],
              ["⚽️","🏀","🏈","⚾️","🎾","🏉","🏓","🏒"]
]
var colorThemes = [[#colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)],[#colorLiteral(red: 1, green: 0.6901960784, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],[#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)],[#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)],[#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 0, alpha: 0.5)],[#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]]

class ViewController: UIViewController {
    
    private let countLabelText = "Счетчик нажатий:"
    private let scoreLabelText = "Количество очков:"
    private var gameTimeOfSeconds = 0
    private var stepTimeOfSeconds = 0
    override func viewDidLoad() {
        newGame()
    }
    
    private lazy var game = Concentration(numberOfPairsCard: self.numberOfPairsCard)
    private lazy var emojiArray = themes[self.numberOfTheme]
    private var emoji: [Int: String] = [:]
    private var numberOfTheme = Int(arc4random_uniform(UInt32(themes.count)))
    private var timerForGame = Timer()
    private var timerForStep = Timer()
    
    var numberOfPairsCard: Int {
        return (self.cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var countLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var gameTimer: UILabel!
    
    @IBOutlet private weak var stepTimer: UILabel!
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBAction private func emojiButtonAction(_ sender: UIButton) {
        
        if let index = self.cardButtons.firstIndex(of: sender) {
            self.game.chooseCard(at: index)
            self.updateViewModel()
        } else {
            print("Unhandled Error!!!")
        }
        
    }
    
    @IBAction func newGameButtonAction(_ sender: Any) {
        self.newGame()
    }
    
    private func newGame(){
        self.game = Concentration(numberOfPairsCard: self.numberOfPairsCard)
        self.numberOfTheme = Int(arc4random_uniform(UInt32(themes.count)))
        self.emojiArray = themes[self.numberOfTheme]
        self.emoji = [:]
        view.backgroundColor = colorThemes[self.numberOfTheme][1]
        self.countLabel.textColor = colorThemes[self.numberOfTheme][0]
        self.scoreLabel.textColor = colorThemes[self.numberOfTheme][0]
        self.gameTimer.textColor = colorThemes[self.numberOfTheme][0]
        self.stepTimer.textColor = colorThemes[self.numberOfTheme][0]
        self.newGameButton.backgroundColor = colorThemes[self.numberOfTheme][0]
        self.newGameButton.tintColor = colorThemes[self.numberOfTheme][1]
        self.gameTimeOfSeconds = 0
        self.updateViewModel()
        timerForGame.invalidate()
        timerForGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionForGame), userInfo: self, repeats: true)
        
    }
    
    @objc func timerActionForGame(){
        self.gameTimeOfSeconds += 1
        self.gameTimer.text = "\(String(self.gameTimeOfSeconds / 3600).paddingToLeft(upTo: 2, using: "0")):\(String((self.gameTimeOfSeconds % 3600) / 60).paddingToLeft(upTo: 2, using: "0")):\(String((self.gameTimeOfSeconds % 3600) % 60).paddingToLeft(upTo: 2, using: "0"))"
    }
    
    @objc func timerActionForStep(){
        self.stepTimeOfSeconds += 1
        self.stepTimer.text = "\(String(self.stepTimeOfSeconds / 3600).paddingToLeft(upTo: 2, using: "0")):\(String((self.stepTimeOfSeconds % 3600) / 60).paddingToLeft(upTo: 2, using: "0")):\(String((self.stepTimeOfSeconds % 3600) % 60).paddingToLeft(upTo: 2, using: "0"))"
    }
    
    private func update(){
        self.countLabel.text = "\(countLabelText) \(self.game.count)"
        self.scoreLabel.text = "\(scoreLabelText) \(self.game.score)"
    }
    
    private func updateViewModel() {
        for index in self.cardButtons.indices {
            let button = self.cardButtons[index]
            let card = self.game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(self.emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6910475492, blue: 0, alpha: 0) : colorThemes[self.numberOfTheme][0]
            }
        }
        self.update()
        self.stepTimeOfSeconds = 0
        timerForStep.invalidate()
        timerForStep = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionForStep), userInfo: self, repeats: true)
    }
    
    private func emoji(for card: Card) -> String {
        if self.emoji[card.identifier] == nil, self.emojiArray.count > 0 {
            self.emoji[card.identifier] = self.emojiArray.remove(at: self.emojiArray.count.arc4random)
        }
        
        return self.emoji[card.identifier] ?? "?"
    }
    
}
