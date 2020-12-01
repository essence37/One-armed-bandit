//
//  MonitorObject.swift
//  One-armed_bandit
//
//  Created by Пазин Даниил on 01.12.2020.
//

import UIKit

class MonitorObject: ObservableObject {
    @Published var firstReelRandomEmoji: Character = "🎰"
    @Published var secondReelRandomEmoji: Character = "🎰"
    @Published var thirdReelRandomEmoji: Character = "🎰"
}

