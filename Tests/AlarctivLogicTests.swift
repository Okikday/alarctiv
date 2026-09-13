//
//  AlarctivLogicTests.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation

@main
struct AlarctivLogicTests {
    static func main() {
        testChallengePhraseBank()
        testChallengeViewModelExactMatching()
        testChallengeViewModelPartialMatching()
        testChallengeViewModelErrorDetection()
        testAntiPasteProtection()
        testAlarmModelFormatting()
        testAlarmCountdownCalculation()
        
        print("\nAll Alarctiv unit tests passed successfully! 🚀")
    }
    
    static func testChallengePhraseBank() {
        print("Testing ChallengePhrase bank...")
        let phrases = ChallengePhrase.phrases
        assert(phrases.count >= 10, "Phrase bank must have at least 10 phrases")
        
        for phrase in phrases {
            assert(!phrase.text.trimmingCharacters(in: .whitespaces).isEmpty, "Phrase text cannot be empty")
        }
        
        let random1 = ChallengePhrase.random()
        let random2 = ChallengePhrase.random(excluding: random1)
        assert(random1.text != random2.text, "Exclusion randomizer should not return identical phrase")
        print("  ✓ ChallengePhrase bank verified (\(phrases.count) phrases).")
    }
    
    static func testChallengeViewModelExactMatching() {
        print("Testing ChallengeViewModel exact match...")
        let testPhrase = ChallengePhrase(text: "The quick brown fox jumps over the lazy dog.")
        let vm = ChallengeViewModel(phrase: testPhrase)
        
        assert(!vm.isExactMatch, "Initial state should not be matched")
        assert(!vm.isCompleted, "Initial state should not be completed")
        assert(vm.progress == 0.0, "Initial progress should be 0.0")
        
        vm.handleTextChange("The quick brown fox jumps over the lazy dog.")
        assert(vm.isExactMatch, "Exact string should trigger isExactMatch")
        assert(vm.isCompleted, "Exact string should mark isCompleted")
        assert(vm.progress == 1.0, "Progress should be 1.0 on completion")
        assert(!vm.hasErrors, "Exact string should have no errors")
        print("  ✓ Exact match verified.")
    }
    
    static func testChallengeViewModelPartialMatching() {
        print("Testing ChallengeViewModel partial match & progress...")
        let testPhrase = ChallengePhrase(text: "Wake up and seize the day.")
        let vm = ChallengeViewModel(phrase: testPhrase)
        
        vm.handleTextChange("Wake")
        assert(!vm.isExactMatch, "Partial prefix should not match completely")
        assert(!vm.hasErrors, "Correct prefix should not have errors")
        assert(vm.progress > 0.1 && vm.progress < 0.5, "Progress should reflect typed fraction")
        print("  ✓ Partial matching and progress bar calculation verified.")
    }
    
    static func testChallengeViewModelErrorDetection() {
        print("Testing ChallengeViewModel typo / error detection...")
        let testPhrase = ChallengePhrase(text: "Wake up and seize the day.")
        let vm = ChallengeViewModel(phrase: testPhrase)
        
        vm.handleTextChange("Woke")
        assert(vm.hasErrors, "Typo ('o' instead of 'a') must be detected as an error")
        assert(!vm.isExactMatch, "Typo cannot trigger match")
        print("  ✓ Typo detection verified.")
    }
    
    static func testAntiPasteProtection() {
        print("Testing anti-paste protection...")
        let testPhrase = ChallengePhrase(text: "Discipline equals freedom, stand up and get moving.")
        let vm = ChallengeViewModel(phrase: testPhrase)
        
        // Simulating immediate paste of 40 characters
        vm.handleTextChange("Discipline equals freedom, stand up and get moving.")
        assert(vm.pasteBlockedWarning, "Instant bulk insertion should flag pasteBlockedWarning")
        assert(!vm.isExactMatch, "Pasted text should be rejected from completing the challenge")
        print("  ✓ Anti-paste defense verified.")
    }
    
    static func testAlarmModelFormatting() {
        print("Testing Alarm model time formatting...")
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 7
        comps.minute = 30
        let date = calendar.date(from: comps) ?? Date()
        
        let alarm = Alarm(time: date, label: "Morning Workout", isEnabled: true)
        assert(alarm.hour == 7, "Hour component should be 7")
        assert(alarm.minute == 30, "Minute component should be 30")
        assert(!alarm.formattedTime.isEmpty, "Formatted time string should not be empty")
        print("  ✓ Alarm model formatting verified.")
    }
    
    static func testAlarmCountdownCalculation() {
        print("Testing Alarm remaining time description...")
        let alarmEnabled = Alarm(time: Date().addingTimeInterval(3600), label: "Test Alarm", isEnabled: true)
        assert(!alarmEnabled.remainingTimeDescription.isEmpty, "Remaining time description should be computed")
        
        let alarmDisabled = Alarm(time: Date().addingTimeInterval(3600), label: "Test Alarm", isEnabled: false)
        assert(alarmDisabled.remainingTimeDescription == "Disabled", "Disabled alarm should display 'Disabled'")
        print("  ✓ Alarm remaining time calculation verified.")
    }
}
