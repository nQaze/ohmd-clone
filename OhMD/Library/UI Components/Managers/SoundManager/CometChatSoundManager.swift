//  CometChatSoundManager.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2020 CometChat Inc. All rights reserved.

// MARK: - Importing Frameworks.

import Foundation
import AVFoundation

// MARK: - Declaration of Enum

public enum Sound {
    case incomingCall
    case incomingMessage
    case incomingMessageForOther
    case outgoingCall
    case outgoingMessage
}

// MARK: - Declaration of Public variable

public var audioPlayer: AVAudioPlayer?

/*  ----------------------------------------------------------------------------------------- */

public final class CometChatSoundManager: NSObject {
    
    /**
       This method play or pause different types of sounds for incoming outgoing calls and messages.
         - Parameters:
           - sound: Specifies an enum of Sound Types such as incomingCall, incomingMessage etc.
              - bool:  Specifies boolean value to play or pause the sound.
       - Author: CometChat Team
       - Copyright:  ©  2020 CometChat Inc.
       */
    public func play(sound: Sound, bool: Bool){
       if bool == true {
       switch sound {
        case .incomingCall:
            guard let soundURL = Bundle.main.url(forResource: "IncomingCall", withExtension: "wav") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch { }
        case .incomingMessage:
            guard let soundURL = Bundle.main.url(forResource: "IncomingMessage", withExtension: "wav") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch { }
        case .outgoingCall:
            guard let soundURL = Bundle.main.url(forResource: "OutgoingCall", withExtension: "wav") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch { }
        case .outgoingMessage:
            guard let soundURL = Bundle.main.url(forResource: "OutgoingMessege", withExtension: "wav") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch { }
        case .incomingMessageForOther:
            guard let soundURL = Bundle.main.url(forResource: "IncomingMessageOther", withExtension: "wav") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch { }
        }
        }else{
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            }
        }
    }
}

/*  ----------------------------------------------------------------------------------------- */
