//
//  ChallengePhrase.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation

struct ChallengePhrase: Identifiable, Equatable {
    let id: UUID
    let text: String
    let hint: String
    
    init(id: UUID = UUID(), text: String, hint: String = "") {
        self.id = id
        self.text = text
        self.hint = hint
    }
}

extension ChallengePhrase {
    static let phrases: [ChallengePhrase] = [
        ChallengePhrase(
            text: "The quick brown fox jumps over the lazy dog.",
            hint: "Classic pangram to test all your fingers."
        ),
        ChallengePhrase(
            text: "I am fully awake and ready to seize today.",
            hint: "Affirmation of wakefulness and energy."
        ),
        ChallengePhrase(
            text: "Pack my box with five dozen liquor jugs.",
            hint: "Short and tricky pangram."
        ),
        ChallengePhrase(
            text: "Rise and shine, the early bird catches the worm.",
            hint: "Classic morning motivation."
        ),
        ChallengePhrase(
            text: "How vexingly quick daft zebras jump!",
            hint: "Fast fingers required for this one."
        ),
        ChallengePhrase(
            text: "Sphinx of black quartz, judge my vow.",
            hint: "Mysterious full alphabet sentence."
        ),
        ChallengePhrase(
            text: "Every morning is a clean slate to begin anew.",
            hint: "Mindful awakening."
        ),
        ChallengePhrase(
            text: "Bright vibrant sunshine breaks through the morning clouds.",
            hint: "Visualizing daylight."
        ),
        ChallengePhrase(
            text: "Jinxed wizards pluck ivy from the big quilt.",
            hint: "Peculiar and brain-activating."
        ),
        ChallengePhrase(
            text: "Discipline equals freedom, stand up and get moving.",
            hint: "No snoozing allowed."
        ),
        ChallengePhrase(
            text: "Two driven jocks help fax my big quiz.",
            hint: "Pangram with challenging key combinations."
        ),
        ChallengePhrase(
            text: "Focus and persistence turn small steps into giant leaps.",
            hint: "Morning focus."
        )
    ]
    
    static func random(excluding current: ChallengePhrase? = nil) -> ChallengePhrase {
        let pool = phrases.filter { $0.text != current?.text }
        return pool.randomElement() ?? phrases[0]
    }
}
