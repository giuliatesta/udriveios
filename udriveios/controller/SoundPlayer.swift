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
