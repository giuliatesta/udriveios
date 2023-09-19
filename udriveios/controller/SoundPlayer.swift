import Foundation
import AVFoundation

/* Class used to play a sound in a view */
class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    var soundUrl: URL?
    var silenceDuration: Double = 3.0
    var repeatSound: Bool = true
    var decreaseSilenceInterval: Double = 30.0
    
    static private var instance : SoundPlayer?;
    
    static func getInstance() -> SoundPlayer {
        if(instance == nil) {
            instance = SoundPlayer()
        }
        return instance!;
    }
    
    override init() {
        super.init()
    }
    
    func initSoundPlayer(soundUrl: URL?, silenceDuration: Double = 3.0, decreaseSilenceInterval: Double = 30.0, repeatSound: Bool = true) {
        self.soundUrl = soundUrl
        self.silenceDuration = silenceDuration
        self.decreaseSilenceInterval = decreaseSilenceInterval
        self.repeatSound = repeatSound
        do {
            self.player = try AVAudioPlayer(contentsOf: soundUrl!)
        } catch {
            print("Error trying playing sound: \(error)")
        }
    }
    
    func play() {
        Timer.scheduledTimer(withTimeInterval: decreaseSilenceInterval, repeats: false, block: { timer in
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
        repeatSound = false     // needed for offset created by silenceDuration after audioPlayerDidFinishPlayer
    }
    
    
    // func from AVAudioPlayerDelegate - automatically called after play
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+silenceDuration) {
            if(self.repeatSound) {
                player.play();
            }
        }
    }
    
    func increaseUrgency() {
        silenceDuration = 0.5
        self.player?.rate = 1.0
    }
    
}
