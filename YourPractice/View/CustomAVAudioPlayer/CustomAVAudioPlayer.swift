//
//  CustomAVAudioPlayer.swift
//  YourPractice
//
//  Created by Devangi Shah on 22/03/19.
//  Copyright © 2019 YourPractice. All rights reserved..
//

import UIKit
import AVFoundation

class CustomAVAudioPlayer: NSObject,AVAudioPlayerDelegate {

    var player:AVAudioPlayer?
    var audioFileName : String = ""
    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    convenience init(strFilePath : String) {
        self.init()
        audioFileName = strFilePath
        setUpAudioPlayer()
    }
    
    func setUpAudioPlayer(){
        if (player != nil) {
            player = nil
        }
        let url = URL.init(fileURLWithPath: audioFileName)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            
        }catch let error as NSError{
            print(error)
        }
    }
    
    func play() {
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
    func stop(){
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func pause(){
        if player?.isPlaying == true{
            player?.pause()
        }
    }
}
