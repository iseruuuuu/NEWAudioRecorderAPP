//
//  AudioPlayer.swift
//  recorderAPPnew
//
//  Created by user on 2020/10/12.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    
    @Published var isPlaying = false
    
    @State var switch_flg: Bool = false
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
   
    /*
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
 */
    
    
  
    func startPlayBack (audio: URL){
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            NSLog("audio session set category faikure")
            print("Playing over the device's speaker failled")
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
    
    
    func replay() {
        if audioPlayer.isPlaying == true {
            audioPlayer.play()
        }else {
            audioPlayer.pause()
        }
    }
    
    
    
      func pauseplay() {
          if audioPlayer.isPlaying {
              audioPlayer.stop()
            print("false")
            switch_flg = false
          }else {
              audioPlayer.play()
            print("true")
            switch_flg = true
           
          }
      }
    
    func pauseplayy() {
        if audioPlayer.isPlaying == false {
           // audioPlayer.play()
            audioPlayer.stop()
            
        }else {
         //   audioPlayer.stop()
            audioPlayer.play()
         
        }
    }
      
 
    

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }

}
 
