//
//  InterfaceController.swift
//  Timer App WatchKit Extension
//
//  Created by 上野博司 on 2020/05/02.
//  Copyright © 2020 hueno. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation


class InterfaceController: WKInterfaceController {
    
    var timer:Timer!
    var timerCount:Int = 0
    var date = Date()
    var initSecond = 1500
    var audioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var min10: WKInterfaceImage!
    @IBOutlet weak var min1: WKInterfaceImage!
    @IBOutlet weak var sec10: WKInterfaceImage!
    @IBOutlet weak var sec1: WKInterfaceImage!
    
    @IBOutlet weak var stopAndStartLabel: WKInterfaceButton!
    var buttonLabel:String = "START"
    
    @IBAction func stopAndStart() {
        if (buttonLabel == "STOP") {
            stopAndStartLabel.setTitle("START")
            buttonLabel = "START"
            self.timer.invalidate()
            NSLog("START")
        } else if (buttonLabel == "START") {
            stopAndStartLabel.setTitle("STOP")
            buttonLabel = "STOP"
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            NSLog("STOP")
        } else if (buttonLabel == "RESTART") {
            stopAndStartLabel.setTitle("START")
            buttonLabel = "START"
            self.timerCount = 0
            timerCounter()
        }
    }
    
    @objc func timerCounter() {
        timerCount += 1
        NSLog("%d",timerCount)
        
        
        let count = initSecond - timerCount
        let min = count / 60
        let sec = count % 60
        
        let minStr = String(min)
        let secStr = String(sec)
        var minArray = minStr.map { String($0) }
        var secArray = secStr.map { String($0) }
        NSLog(minStr)
        NSLog(secStr)
        
        if (minArray.count == 1) {
            minArray.append("0")
            minArray.append(minArray[0])
            minArray.removeFirst()
        }
        if (secArray.count == 1) {
            secArray.append("0")
            secArray.append(secArray[0])
            secArray.removeFirst()
        }
        
        self.min10.setImageNamed(minArray[0]+"_w.png")
        self.min1.setImageNamed(minArray[1]+"_w.png")
        self.sec10.setImageNamed(secArray[0]+"_w.png")
        self.sec1.setImageNamed(secArray[1]+"_w.png")
        
        if (min == 0) {
            // アラート
            self.min10.setImageNamed(minArray[0]+"_r.png")
            self.min1.setImageNamed(minArray[1]+"_r.png")
            self.sec10.setImageNamed(secArray[0]+"_r.png")
            self.sec1.setImageNamed(secArray[1]+"_r.png")
        }
        if (min == 0 && sec == 0) {
            self.timer.invalidate()
            stopAndStartLabel.setTitle("RESTART")
            buttonLabel = "RESTART"
            
            // 音を鳴らす
            self.audioPlayer.play()
            NSLog("ブルブル")
            // 振動させる
            WKInterfaceDevice.current().play(WKHapticType.notification)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        //      timerCount += 1
        //     NSLog("%d",timerCount)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.min10.setImageNamed("2_w.png")
        self.min1.setImageNamed("5_w.png")
        self.sec10.setImageNamed("0_w.png")
        self.sec1.setImageNamed("0_w.png")
        stopAndStartLabel.setTitle(buttonLabel)
        
        
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "alert_1", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            self.audioPlayer.prepareToPlay()
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
