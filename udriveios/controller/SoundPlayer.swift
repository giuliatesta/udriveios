//
//  SoundPlayer.swift
//  udriveios
//
//  Created by Giulia Testa on 17/07/23.
//

import Foundation
import AVFoundation


class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    let soundUrl: URL?
    var silenceDuration: Double
    let decreaseSilenceInterval: Double
    
    init(soundUrl: URL?, silenceDuration: Double = 3.0, decreaseSilenceInterval: Double = 30.0) {
        self.soundUrl = soundUrl
        self.silenceDuration = silenceDuration
        self.decreaseSilenceInterval = decreaseSilenceInterval
        do {
            self.player = try AVAudioPlayer(contentsOf: soundUrl!)
        } catch {
            print("Error trying playing sound: \(error)")
        }
    }
    
    func play() {
        var timer = Timer.scheduledTimer(withTimeInterval: decreaseSilenceInterval, repeats: false, block: { timer in
            self.increaseUrgency()
            timer.invalidate()
        });
        
        self.player!.delegate = self
        player!.enableRate = true
        player!.rate = 0.75
        player!.play()
    }

    func stop() {
        player?.stop();
    }
    
    
    // func from AVAudioPlayerDelegate - automatically called after play
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+silenceDuration) {
            player.play();
        }
    }
    
    func increaseUrgency() {
        silenceDuration = 0.5
        self.player?.rate = 1.0
    }
    
}

/*
class SoundPlayer: AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?

    func playSound(withFileName fileName: String, loopCount: Int, silenceDuration: TimeInterval) {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("Sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = loopCount - 1 // Set the number of loops, subtracting 1 to account for initial play
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player.numberOfLoops > 0 {
            // Pause for the specified silence duration between loops
            DispatchQueue.main.asyncAfter(deadline: .now() + silenceDuration) {
                player.play()
            }
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
*/
