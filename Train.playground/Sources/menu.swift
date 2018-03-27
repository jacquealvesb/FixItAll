import PlaygroundSupport
import SpriteKit

public class MainMenu : SKScene {
    
    public override func didMove(to view: SKView){
        self.backgroundColor = NSColor(red: 0.43, green: 0.17, blue: 0.0, alpha: 1.0)
        
        let playButton = createSprite(imageName: "play_button", at: CGPoint(x: -200, y: 0), scale: 2.0)
        
        let train = createSprite(imageName: "train_side", at: CGPoint(x: (scene!.size.width)/2 - 180, y: -180), scale: 1.3)
        
        
        self.addChild(playButton)
        self.addChild(train)
    }
    
    public override func mouseDown(with: NSEvent) {
        let location = with.location(in: self)
        let node = self.atPoint(location)
        
        if(node.name == "play_button"){
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFit
                
                view!.presentScene(scene)
            }
        }
    }
    
    public func createSprite(imageName img:String, at point:CGPoint, scale:CGFloat) -> SKSpriteNode{
        let sprite = SKSpriteNode(imageNamed: img)
        sprite.name = img
        
        sprite.xScale = scale
        sprite.yScale = scale
        
        sprite.position = point
        
        return sprite
    }
}
