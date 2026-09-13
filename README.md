# Alarctiv ⏰⚡️

> **The alarm app that compulses you to wake up.**

Alarctiv is a cross-platform (macOS & iOS) alarm application built with modern **SwiftUI** and **Swift 6**. When it's time to wake up, the alarm blares continuous looping audio and **refuses to stop** until you physically type out a randomized challenge phrase. By the time you complete typing the phrase, your brain is fully awake.

---

## Features

- **Compulsory Awakening Challenge**:
  - Un-stoppable alarm audio loops infinitely (`numberOfLoops = -1`).
  - Dismiss button remains strictly locked until user input matches the challenge phrase 100% character-for-character.
- **Randomized Phrase Engine**:
  - Bank of 12+ brain-activating phrases including classic pangrams (*"The quick brown fox jumps over the lazy dog"*), tongue twisters, and focus quotes.
  - Automatically picks a fresh phrase on every wake-up drill or alarm event.
- **Real-Time Visual Typing Feedback**:
  - Instant character-by-character color matching:
    - 🟢 **Emerald Green**: Correctly typed characters
    - 🔴 **Crimson Red**: Mismatched characters / typos
    - 🔵 **Vibrant Blue**: Active cursor indicator
    - ⚪ **Muted Grey**: Pending characters
  - Live progress bar tracking completion percentage.
- **Anti-Cheat System**:
  - Prevents clipboard paste operations to ensure physical typing.
  - Auto-correction and auto-capitalization disabled for authentic keyboard precision.
- **Sound Engine**:
  - High-clarity synthetic dual-frequency alert tone (`alarm_beep.wav`).
  - Configured with `AVAudioSession` `.playback` category on iOS to bypass physical mute/silent switches.
  - Graceful fallbacks on both macOS and iOS.
- ⏱️ **Live Digital Clock**:
  - Real-time pulsing digital clock displaying hours, minutes, seconds, AM/PM, and date.
- **Quick Drill Test**:
  - "Test Wake-Up Challenge Now" button allows instant testing of audio looping and typing validation without waiting for scheduled times.
- **Cross-Platform (macOS + iOS)**:
  - Designed for macOS 15+ and iOS 18+ / iOS 26+ (compatible with the iOS Simulator and physical devices).
  - Modern Blue & Purple gradient design system.

---

## Architecture

The app adheres to Apple's modern SwiftUI architecture standards and modular component structure:

```
alarctiv/
├── Models/
│   ├── Alarm.swift                 # Identifiable & Codable alarm model
│   └── ChallengePhrase.swift       # Bank of 12+ randomized awakening sentences
├── Services/
│   ├── SoundManager.swift          # AVAudioPlayer loop engine with AVAudioSession setup
│   ├── AlarmScheduler.swift        # UNUserNotificationCenter alerts & minute monitor
│   └── AlarmStorage.swift          # UserDefaults JSON persistence
├── ViewModels/
│   ├── AlarmViewModel.swift        # @Observable state for alarm scheduling & trigger flow
│   └── ChallengeViewModel.swift    # @Observable state for real-time typing verification
├── Views/
│   ├── AlarmListView.swift         # Main dashboard with digital clock & alarm list
│   ├── AlarmEditSheet.swift        # Responsive card-based modal to add/edit alarms
│   ├── ChallengeView.swift         # Locked full-screen ringing alarm challenge
│   └── SuccessDismissView.swift    # Rewarding celebration screen upon completion
├── Components/
│   ├── DigitalClockView.swift      # Live ticking clock with AM/PM accent
│   ├── AlarmCardView.swift         # Modular alarm toggle item
│   ├── TypingCardView.swift        # Interactive real-time typing container
│   ├── SoundWaveIndicator.swift    # Animated pulsing audio wave indicator
│   └── PrimaryButton.swift         # Reusable styled button with gradients
└── Resources/
    └── alarm_beep.wav              # High-energy looping alarm audio
```

---

## 🚀 Getting Started

### Requirements
- **macOS Sequoia** (macOS 15.0 or later)
- **Xcode 16+** with Swift 6
- Target Platforms: **macOS 15.7+**, **iOS 18.0+ / 26.2+**

### Open in Xcode
```bash
open alarctiv.xcodeproj
```

### Run on macOS (Native Desktop App)
1. Select the **alarctiv** scheme in Xcode.
2. Set the destination to **My Mac**.
3. Press `Cmd + R` to build and run.

Or compile via terminal:
```bash
xcodebuild -scheme alarctiv -destination 'platform=macOS' build
```

### Run on iOS Simulator
1. Select the **alarctiv** scheme in Xcode.
2. Set destination to any simulator (e.g. **iPhone 17** or **iPhone 14 Pro**).
3. Press `Cmd + R` to build and run.

Or compile via terminal:
```bash
xcodebuild -scheme alarctiv -destination 'platform=iOS Simulator,name=iPhone 17' build
```

---

## 🧪 Testing & CI

### Running Unit Tests Locally
```bash
swiftc alarctiv/Models/Alarm.swift \
       alarctiv/Models/ChallengePhrase.swift \
       alarctiv/ViewModels/ChallengeViewModel.swift \
       Tests/AlarctivLogicTests.swift \
       -o ./test_runner && ./test_runner && rm -f ./test_runner
```

### Continuous Integration
GitHub Actions workflow is configured in [`.github/workflows/ci.yml`](.github/workflows/ci.yml) to automatically validate logic tests, build the macOS target, and build the iOS target on every push and pull request.
