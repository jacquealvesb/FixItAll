//: # Fix it all 
//: Fix it all is a game made for macOS built wuth SpriteKit, AVFoundation and AppKit. I'll show you how to play

//: ## #1 step
//: When a track is broken, a button shows up. You have to press it to repair the track
/*:
 ![repair button](repair_button.png)
 */
//: ## #2 step
//: When you press the button, arrows are shonwed on the corner of the screen. Use your keyboard to press the indicated arrow
/*:
 ![arrow](arrowHighlighted_button.png)
 */

//: ## #3 step
//: When you finish to press all 4 arrows, the status bar increases. When you complete the sequence 3 times, the status bar is fully completed and the track is fixed

//: # Be quick!
//: ## Fix the track before the train reaches the broken part
//: Now that you know the basics, [let's have some fun](Game)?

import PlaygroundSupport
import SpriteKit


let sceneView = SKView(frame: CGRect(x: 0.0, y: 0.0, width: 800, height: 600))

if let welcome = Welcome(fileNamed: "WelcomeScene") {
    welcome.scaleMode = .aspectFit
    
    sceneView.presentScene(welcome)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
