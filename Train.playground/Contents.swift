import PlaygroundSupport
import SpriteKit

let sceneView = SKView(frame: CGRect(x: 0.0, y: 0.0, width: 800, height: 600))

if let menu = MainMenu(fileNamed: "MainMenu") {
    menu.scaleMode = .aspectFit
    
    sceneView.presentScene(menu)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

