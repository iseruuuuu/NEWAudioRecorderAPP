
import SwiftUI
import Speech
import MediaPlayer
import AVKit
import AVFoundation
import Combine
import MobileCoreServices


struct RecordingsList: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var value: Double = 0
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL, audioRecorder: audioRecorder)
                
            }
            .onDelete(perform: delete)
            
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

//struct RecordingRow: View {

struct RecordingRow: View {
    
    var audioURL: URL
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer = AudioPlayer()
    @State private var value: Double = 0
    @State var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    @State var starttime : Float = 0
    @State var finishtime : Float = 0
    @State var nomove = 0.0
    
    @State var isplaying = false
    
    @State var switch_flg: Bool = false
    
    func play(){
        if audioPlayer.isPlaying{
            audioPlayer.audioPlayer.play()
        }
        else{
            audioPlayer.audioPlayer.pause()
        }
    }
    
    func play2() {
        if audioPlayer.isPlaying {
            audioPlayer.audioPlayer.play()
            
        }else {
            self.audioPlayer.startPlayBack(audio: self.audioURL)
            
            
        }
    }
    
    
    
    func pauseplay() {
        if audioPlayer.isPlaying {
            audioPlayer.audioPlayer.stop()
        }else {
            audioPlayer.audioPlayer.play()
            
        }
    }
    
    
    
    func startAnimation() {
        var power : Float = 0
        for i in 0..<audioPlayer.audioPlayer.numberOfChannels{
            power += audioPlayer.audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        let animated = CGFloat(value) * (maxWidth / 55)
        withAnimation(Animation.linear(duration: 0.01)) {
            self.animatedValue = animated + 55
        }
    }
    
    
    
    
    func getStartTime(value: TimeInterval)->String{
        return "\(Int(starttime / 60)):\(Int(starttime.truncatingRemainder(dividingBy: 60)) < 10 ? "0" : "")\(Int(starttime.truncatingRemainder(dividingBy: 60)))"
    }
    
    func getFinishTime(value: TimeInterval)-> String {
        return "\(Int(finishtime / 60)):\(Int(finishtime.truncatingRemainder(dividingBy: 60)) < 10 ? "0" : "")\(Int(finishtime.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    
    
    
    
    var body: some View {
        VStack(alignment:.center){
            Text("\(audioURL.lastPathComponent)")
                .font(.body)
                .padding(10)
            Slider(value: Binding(get: {time}, set: { (newValue) in
                time = newValue
                audioPlayer.audioPlayer.currentTime = Double(time) * audioPlayer.audioPlayer.duration
                audioPlayer.audioPlayer.play()
            }))
            .onReceive(timer) { (_) in
                if audioPlayer.isPlaying {
                    audioPlayer.audioPlayer.updateMeters()
                    audioPlayer.isPlaying = true
                    time = Float(audioPlayer.audioPlayer.currentTime / audioPlayer.audioPlayer.duration)
                    
                    starttime = Float(audioPlayer.audioPlayer.currentTime)
                    
                    finishtime = Float(audioPlayer.audioPlayer.duration - audioPlayer.audioPlayer.currentTime)
                    
                    startAnimation()
                    
                } else {
                    audioPlayer.isPlaying = false
                }
            }
            //  }
            
            
            HStack {
                
                Text(getStartTime(value: TimeInterval(starttime)))
                    .fontWeight(.semibold)
                Spacer()
                Text(getFinishTime(value: TimeInterval(finishtime)))
                    .fontWeight(.semibold)
            }
            
            
            
            HStack(spacing: 22){
                //戻る機能
                Button(action: {
                }) {
                    Image(systemName: "backward.fill")
                        
                        .onTapGesture {
                            if audioPlayer.isPlaying {
                                audioPlayer.audioPlayer.currentTime -= 10000
                            }
                            else {
                            }
                        }
                        .imageScale(.medium)
                        .foregroundColor(.blue)
                        .font(.title)
                }
                
                Button(action: {
                }) {
                    Image(systemName: "gobackward.10")
                        .onTapGesture {
                            if audioPlayer.isPlaying  {
                                audioPlayer.audioPlayer.currentTime -= 10
                            }
                            else {
                            }
                        }
                        .imageScale(.medium)
                        .foregroundColor(.blue)
                        .font(.title)
                }

                if audioPlayer.isPlaying {
                    if (switch_flg) {
                        Button(action: {
                        }) {
                            Image(systemName: "pause.fill")
                                .onTapGesture{
                                    switch_flg = false
                                    self.audioPlayer.pause()
                                }
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .font(.title)
                    }else {
                        Button(action: {
                        }) {
                            Image(systemName: "play.fill")
                                .onTapGesture{
                                    switch_flg = true
                                    self.audioPlayer.play()
                                }
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                        .font(.title)
                    }
                    
                    
                }else {
                    Button(action: {
                    }) {
                        Image(systemName: "play.fill")
                            .onTapGesture{
                                switch_flg = true
                                self.audioPlayer.startPlayBack(audio: self.audioURL)
                            }
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .font(.title)
                    
                }
                
                
                /*
                 
                 if ( switch_flg ) {
                 // if audioPlayer.isPlaying {
                 Button(action: {
                 }) {
                 Image(systemName: "play.fill")
                 .onTapGesture{
                 print("false")
                 switch_flg = false
                 //self.audioPlayer.startPlayBack(audio: self.audioURL)
                 }
                 .imageScale(.large)
                 .foregroundColor(.blue)
                 }
                 .font(.title)
                 }else {
                 
                 Button(action: {
                 }) {
                 Image(systemName: "pause.fill")
                 .onTapGesture{
                 print("true")
                 switch_flg = true
                 // self.audioPlayer.pauseplay()
                 }
                 .imageScale(.large)
                 .foregroundColor(.blue)
                 }
                 .font(.title)
                 }
                 
                 */
                
                
                
                /*
                 
                 //再生の処理
                 if audioPlayer.isPlaying == false {
                 Button(action: {
                 }) {
                 Image(systemName: "play.fill")
                 // Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                 .onTapGesture{
                 self.audioPlayer.startPlayBack(audio: self.audioURL)
                 
                 }
                 .imageScale(.large)
                 .foregroundColor(.blue)
                 }
                 .font(.title)
                 } else if audioPlayer.isPlaying == true {
                 Button(action: {
                 }) {
                 Image(systemName: "play.fill")
                 // Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                 .onTapGesture{
                 self.audioPlayer.audioPlayer.pause()
                 }
                 .imageScale(.large)
                 .foregroundColor(.blue)
                 }
                 .font(.title)
                 }else {
                 Button(action: {
                 }) {
                 Image(systemName: "pause.fill")
                 // Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                 .onTapGesture{
                 self.audioPlayer.audioPlayer.play()
                 }
                 .imageScale(.large)
                 .foregroundColor(.blue)
                 }
                 .font(.title)
                 }
                 
                 */
                
                
                /*
                 
                 Button(action: play2) {
                 Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                 .font(.title)
                 .imageScale(.medium)
                 .foregroundColor(.blue)
                 }
                 
                 
                 */
                
                
                //15秒進める。
                Button(action: {
                }) {
                    Image(systemName: "goforward.10").onTapGesture {
                        if audioPlayer.isPlaying {
                            audioPlayer.audioPlayer.currentTime += 10
                        } else {
                            
                        }
                    }
                    .font(.title)
                    .imageScale(.medium)
                    .foregroundColor(.blue)
                }
                
                
                
                Button(action: {
                }) {
                    Image(systemName: "forward.fill").onTapGesture {
                        if audioPlayer.isPlaying {
                            audioPlayer.audioPlayer.currentTime += 10000
                        }
                        else {
                        }
                    }
                    .imageScale(.medium)// システムアイコンを指定
                    .foregroundColor(.blue)
                }
                .font(.title)
            }
            
        }
    }
}


struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}