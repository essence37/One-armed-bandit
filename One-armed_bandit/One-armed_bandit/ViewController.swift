//
//  ViewController.swift
//  One-armed_bandit
//
//  Created by Пазин Даниил on 30.11.2020.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    enum GameCondition {
        case gameIsActivated
        case gameIsStopped
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var leverButton: UIButton!
    @IBOutlet weak var firstLeverImage: UIImageView!
    @IBOutlet weak var secondLeverImage: UIImageView!
    @IBOutlet weak var thirdLeverImage: UIImageView!
    @IBOutlet weak var firstReelEmojiLabel: UILabel!
    @IBOutlet weak var secondReelEmojiLabel: UILabel!
    @IBOutlet weak var thirdReelEmojiLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func pullTheLever1(_ sender: Any) {
        UIView.transition(with: secondLeverImage, duration: 0.04, options: .transitionCrossDissolve) {
            self.firstLeverImage.isHidden = true
            self.secondLeverImage.isHidden = false
        } completion: { _ in
            UIView.transition(with: self.thirdLeverImage, duration: 0.04, options: .transitionCrossDissolve) {
                self.secondLeverImage.isHidden = true
                self.thirdLeverImage.isHidden = false
            } completion: { _ in
                UIView.transition(with: self.firstLeverImage, duration: 0.3, options: .transitionCrossDissolve) {
                    self.thirdLeverImage.isHidden = true
                    self.secondLeverImage.isHidden = true
                    self.firstLeverImage.isHidden = false
                } completion: { _ in
                    switch self.gameState {
                    case .gameIsActivated:
                        self.gameState = .gameIsStopped
                        if self.firstReelEmojiLabel.text == self.secondReelEmojiLabel.text &&
                            self.firstReelEmojiLabel.text == self.thirdReelEmojiLabel.text {
                            self.winLabel.isHidden = false
                        }
                    case .gameIsStopped:
                        self.winLabel.isHidden = true
                        self.gameState = .gameIsActivated
                        self.startSpin()
                    }
                }
            }
        }
    }

    // MARK: - Constants and Variables
    let reelsEmoji: [Character] = ["🥳", "👑", "🐱", "🦄", "⭐️", "🪐", "🍒", "🍓", "💰", "🎁", "❤️"]
    let object = MonitorObject()
    var subscriptions: Set<AnyCancellable> = []
    let spinInterval = 0.1
    var gameState: GameCondition = .gameIsStopped
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods
    func startSpin() {
        let timer = Timer
            .publish(every: spinInterval, on: .main, in: .common)
            .autoconnect()
        
        
        let publisher = timer
            .sink { _ in
                guard self.gameState != .gameIsStopped else { timer.upstream.connect().cancel()
                    return
                }
                self.object.firstReelRandomEmoji = self.reelsEmoji.randomElement()!
                self.object.secondReelRandomEmoji = self.reelsEmoji.randomElement()!
                self.object.thirdReelRandomEmoji = self.reelsEmoji.randomElement()!
            }
            .store(in: &subscriptions)
        
        let subscription = object.objectWillChange
            .sink {
                UIView.transition(with: self.firstReelEmojiLabel, duration: self.spinInterval, options: .transitionFlipFromTop) {
                    self.firstReelEmojiLabel.text = String(self.object.firstReelRandomEmoji)
                }
                UIView.transition(with: self.firstReelEmojiLabel, duration: self.spinInterval, options: .transitionFlipFromTop) {
                    self.secondReelEmojiLabel.text = String(self.object.secondReelRandomEmoji)
                }
                UIView.transition(with: self.firstReelEmojiLabel, duration: self.spinInterval, options: .transitionFlipFromTop) {
                    self.thirdReelEmojiLabel.text = String(self.object.thirdReelRandomEmoji)
                }
            }
            .store(in: &subscriptions)
    }
}

