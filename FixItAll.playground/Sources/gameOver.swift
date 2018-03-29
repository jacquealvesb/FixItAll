import PlaygroundSupport
import SpriteKit

public class GameOver : SKScene {
    
    public override func didMove(to view: SKView){
        self.backgroundColor = NSColor(red: 0.43, green: 0.17, blue: 0.0, alpha: 1.0)
        
        let homeButton = createSprite(imageName: "home_button", at: CGPoint(x: -150, y: 0))
        let restarButton = createSprite(imageName: "restart_button", at: CGPoint(x: 150, y: 0))
        let train = createSprite(imageName: "train_side", at: CGPoint(x: (scene!.size.width)/2 - 180, y: -180))
        
        let text = SKLabelNode(fontNamed: "Arial")
        
        text.fontSize = 40
        text.fontColor = SKColor.white
        text.position = CGPoint(x: 0, y: (scene!.size.width)/2 - 200)
        
        text.text = "You traveled \(loadDistance ())m"
        
        self.addChild(text)
        self.addChild(homeButton)
        self.addChild(restarButton)
        self.addChild(train)
    }
    
    func loadDistance () -> Float {
        return UserDefaults.standard.float(forKey: "distance")
    }
    
    public override func mouseDown(with: NSEvent) {
        let location = with.location(in: self)
        let node = self.atPoint(location)
        
        if(node.name == "home_button"){
            if let scene = MainMenu(fileNamed: "MainMenu") {
                scene.scaleMode = .aspectFit
                
                view!.presentScene(scene)
            }
        } else if(node.name == "restart_button"){
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFit
                
                view!.presentScene(scene)
            }
        }
    }
    
    public func createSprite(imageName img:String, at point:CGPoint) -> SKSpriteNode{
        let sprite = SKSpriteNode(imageNamed: img)
        sprite.name = img
        
        sprite.xScale = 1.3
        sprite.yScale = 1.3
        
        sprite.position = point
        
        return sprite
    }
}
