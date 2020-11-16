//
//  AudioRecorderAPPApp.swift
//  AudioRecorderAPP
//
//  Created by user on 2020/11/14.
//

import SwiftUI

@main
struct AudioRecorderAPPApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecorder: AudioRecorder())
        }
    }
}
