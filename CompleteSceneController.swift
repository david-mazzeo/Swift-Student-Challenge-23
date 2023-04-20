//
//  CompleteScene.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 17/4/2023.
//

import SpriteKit

class CompleteScene: SKScene {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    override func didMove(to view: SKView) {
        self.scene?.name = "Complete"
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        
        let flash = SKShapeNode()
        flash.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight)).cgPath
        flash.fillColor = .white
        flash.zPosition = 0
        
        self.addChild(flash)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
           SKAction.run {
               self.displayTV(dialogue: "Hey, wake up!", speaker: "Scientist")
           }, SKAction.wait(forDuration: 2), SKAction.run {
               self.scene?.name = "WokenUp"
               self.hideTV()
           }, SKAction.wait(forDuration: 1), SKAction.run {
               flash.run(SKAction.fadeAlpha(to: 0, duration: 2))
           }, SKAction.wait(forDuration: 3), SKAction.run {
               self.displayTV(dialogue: "I guess we did it...", speaker: "Scientist")
           }, SKAction.wait(forDuration: 3), SKAction.run {
               self.hideTV()
           }, SKAction.wait(forDuration: 2), SKAction.run {
               self.displayTV(dialogue: "The sun's out for the first time in years, and I can hear the city running as usual in the background.", speaker: "Scientist")
           }, SKAction.wait(forDuration: 3), SKAction.run {
               self.hideTV()
           }, SKAction.wait(forDuration: 2), SKAction.run {
               self.displayTV(dialogue: "Nice work, captain.", speaker: "Scientist")
           }, SKAction.wait(forDuration: 3), SKAction.run {
               self.hideTV()
           }, SKAction.wait(forDuration: 1), SKAction.run {
               NotificationCenter.default.post(Notification(name: Notification.Name("returnToTitle")))
           }]))
    }
    
}
