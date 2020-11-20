//
//  AudioPlayer.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/12.
//

import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer!
    @Published var isPlaying = false
    @State var switch_flg: Bool = false
    
    func startPlayBack (audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("再生成功")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
     
    func stop() {
        audioPlayer.stop()
    }
    func play() {
        audioPlayer.play()
    }
    func pause() {
        audioPlayer.pause()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
 
