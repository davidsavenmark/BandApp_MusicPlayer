//
//  PlayerView.swift
//  BandApp_MusicPlayer
//
//  Created by David on 2021-02-08.
//

import Foundation
import SwiftUI
import Firebase
import SwiftAudioPlayer
import AVFoundation

struct PlayerView : View {
    @State  var album : Album
    @State  var song : Song
    
    @State var player = AVPlayer()
    

    
    @State var isPlaying : Bool = false
    
    
    // Body of the musicplayer view, including its buttons.
    var body: some View {
        ZStack {
            Image(album.image).resizable().edgesIgnoringSafeArea(.all)
            Blur(style: .dark).edgesIgnoringSafeArea(.all)
            VStack{
        
                Spacer()
                AlbumArt(album: album, isWithText: false)
                Text(song.name).font(.title).fontWeight(.light).foregroundColor(.white)
                Spacer()
                ZStack {
                    
                    Color.white.cornerRadius(20).shadow(radius: 10)
                    
                    HStack {
                        
                        Button(action: self.previous, label: {
                            Image(systemName: "arrow.left.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.blue)
                        
                        Button(action: self.playPause, label: {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill").resizable()
                        }).frame(width: 70, height: 70, alignment: .center).padding()
                        
                        Button(action: self.next, label: {
                            Image(systemName: "arrow.right.circle").resizable()
                        }).frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.blue)
                            
                        }
                    
                }.edgesIgnoringSafeArea(.all).frame(height: 170, alignment: .center)
            }
        }.onAppear() {
            self.playSong()
            
        }
    }
    
    // This is the function that basically loads your uploaded songs from storage in firebase, depending on what song you play. 
    func playSong () {
        let storage = Storage.storage().reference(forURL: self.song.file)
         storage.downloadURL { (url, error) in
             if error != nil {
                 print(error)
             } else {
                 
                 do {
                     try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                  }
                  catch {
                     // report for an error
                  }
                 player = AVPlayer(playerItem: AVPlayerItem(url: url!))
                 player.play()
                 
             }
         }
    }
        
    func playPause() {
        self.isPlaying.toggle()
        if isPlaying == false {
            player.pause()
          
        }else{
        player.play()
            
            
        }
        
    }
    
    func next () {
        if let currentIndex = album.songs.firstIndex(of: song){
            if currentIndex == album.songs.count - 1 {
                
            }else{
                player.pause()
                song = album.songs[currentIndex + 1]
                self.playSong()
            }
            
        }
                
    }
    
    func previous () {
        if let currentIndex = album.songs.firstIndex(of: song){
            if currentIndex == 0 {
                
            }else{
                player.pause()
                song = album.songs[currentIndex - 1]
                self.playSong()
            }
            
        }
        
    }
    
    
}
