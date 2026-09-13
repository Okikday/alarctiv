//
//  ChallengeViewModel.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation
import SwiftUI

enum CharacterMatchStatus: Equatable {
    case correct
    case incorrect
    case pending
    case currentCursor
}

@Observable
final class ChallengeViewModel {
    var currentPhrase: ChallengePhrase
    var userInput: String = ""
    var isCompleted: Bool = false
    var pasteBlockedWarning: Bool = false
    var startTime: Date?
    var elapsedSeconds: Int = 0
    
    private var lastInputCount: Int = 0
    
    init(phrase: ChallengePhrase? = nil) {
        self.currentPhrase = phrase ?? ChallengePhrase.random()
        self.startTime = Date()
    }
    
    var targetText: String {
        currentPhrase.text
    }
    
    var targetCharacters: [Character] {
        Array(targetText)
    }
    
    var userCharacters: [Character] {
        Array(userInput)
    }
    
    var progress: Double {
        guard !targetText.isEmpty else { return 0.0 }
        let correctCount = zip(targetCharacters, userCharacters).filter { $0 == $1 }.count
        return min(1.0, Double(correctCount) / Double(targetCharacters.count))
    }
    
    var isExactMatch: Bool {
        userInput == targetText
    }
    
    /// Returns the character match status array for every letter in the target phrase
    var characterStatuses: [CharacterMatchStatus] {
        let targets = targetCharacters
        let inputs = userCharacters
        
        var statuses: [CharacterMatchStatus] = []
        statuses.reserveCapacity(targets.count)
        
        for i in 0..<targets.count {
            if i < inputs.count {
                if inputs[i] == targets[i] {
                    statuses.append(.correct)
                } else {
                    statuses.append(.incorrect)
                }
            } else if i == inputs.count {
                statuses.append(.currentCursor)
            } else {
                statuses.append(.pending)
            }
        }
        return statuses
    }
    
    var hasErrors: Bool {
        for (i, char) in userCharacters.enumerated() {
            if i < targetCharacters.count {
                if char != targetCharacters[i] {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }
    
    func reset(newPhrase: ChallengePhrase? = nil) {
        currentPhrase = newPhrase ?? ChallengePhrase.random(excluding: currentPhrase)
        userInput = ""
        isCompleted = false
        pasteBlockedWarning = false
        lastInputCount = 0
        startTime = Date()
    }
    
    func handleTextChange(_ newValue: String) {
        // Anti-cheat detection: if input increases by more than 4 characters at once, block it as paste
        if newValue.count > lastInputCount + 4 {
            pasteBlockedWarning = true
            // Revert back to previous input to force physical typing
            userInput = String(newValue.prefix(lastInputCount + 1))
            lastInputCount = userInput.count
            return
        }
        
        pasteBlockedWarning = false
        lastInputCount = newValue.count
        userInput = newValue
        
        if isExactMatch {
            isCompleted = true
        }
    }
}
