//
//  SoundPlayer.swift
//  QuizApp
//
//  Created by Davide Savarro on 21/02/2020.
//  Copyright © 2020 Davide Savarro. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class SoundPlayer {
    
    
    private var soundID: SystemSoundID = 0
    
    public init(named name: String) {
        if let soundURL = soundURL(forName: name) {
            let status = AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            if status != noErr {
                print("Unable to create sound at URL: '\(name)'")
                soundID = 0
            }
        }
    }
    
    public func play() {
        if soundID != 0 {
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    private func soundURL(forName name: String) -> URL? {
        
        let fileExtensions = ["m4a", "wav", "mp3", "aac", "adts", "aif", "aiff", "aifc", "caf", "mp4"]
        
        for fileExtention in fileExtensions {
            if let soundURL = Bundle.main.url(forResource: name, withExtension: fileExtention) {
                return soundURL
            }
        }
        print("Unable to find sound file with name '\(name)'")
        return nil
    }
    
    deinit {
        if soundID != 0 {
            AudioServicesDisposeSystemSoundID(soundID)
        }
    }
    
}
