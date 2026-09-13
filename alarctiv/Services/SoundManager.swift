//
//  SoundManager.swift
//  alarctiv
//
//  Created by Okikiola on 13/09/2026.
//

import Foundation
import AVFoundation
#if canImport(AppKit)
import AppKit
#endif

final class SoundManager: NSObject, AVAudioPlayerDelegate, @unchecked Sendable {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private(set) var isPlaying: Bool = false
    
    private override init() {
        super.init()
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        #if os(iOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("SoundManager: Failed to set AVAudioSession category: \(error.localizedDescription)")
        }
        #endif
    }
    
    /// Starts playing the alarm in an infinite loop.
    func playAlarm(soundName: String = "alarm_beep") {
        #if os(iOS)
        configureAudioSession()
        #endif
        
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") ??
                             Bundle.main.url(forResource: "alarm_beep", withExtension: "wav") else {
            print("SoundManager: Sound file '\(soundName)' not found in bundle.")
            playFallbackBeep()
            return
        }
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            print("SoundManager: Started looping alarm sound.")
        } catch {
            print("SoundManager: Could not instantiate AVAudioPlayer: \(error.localizedDescription)")
            playFallbackBeep()
        }
    }
    
    /// Stops the alarm audio completely.
    func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        print("SoundManager: Stopped alarm sound.")
    }
    
    /// Plays a short 2-second preview of the alarm sound.
    func playPreview(soundName: String = "alarm_beep") {
        #if os(iOS)
        configureAudioSession()
        #endif
        
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") ??
                             Bundle.main.url(forResource: "alarm_beep", withExtension: "wav") else {
            return
        }
        
        do {
            audioPlayer?.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = 0 // Play once
            audioPlayer?.volume = 0.8
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("SoundManager preview error: \(error.localizedDescription)")
        }
    }
    
    private func playFallbackBeep() {
        #if os(iOS)
        AudioServicesPlaySystemSound(1005) // System SMS/alert sound
        #elseif os(macOS)
        NSSound.beep()
        #endif
    }
}
