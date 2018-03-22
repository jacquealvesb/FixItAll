import PlaygroundSupport
import SpriteKit

public class Track {
    var name:String
    var speed:CGFloat
    
    var sprite:SKSpriteNode? = nil
    var type: String = ""                                       //Either a normal track or a broken one
    var fixed:Bool = false
    
    init (name:String, initialSpeed:CGFloat, initialY:CGFloat) {                      //Sets the name of the track and creates its sprite
        self.name = name
        self.speed = initialSpeed
        
        sprite = createTrack(atY: initialY)
    }
    
    func createTrack(atY y:CGFloat) -> SKSpriteNode {           //Creates the sprite of the track
        let track = SKSpriteNode(imageNamed: drawTrack())
        
        track.name = name
        track.xScale = 1.3
        track.yScale = 1.3
        
        track.position = CGPoint(x: -40, y: y)                  //Initial position of the track
        
        let trackAction = SKAction.repeatForever(               //Track movement
            SKAction.moveBy(x: 0.0,
                            y: -speed,
                            duration: 1.0)
        )
        
        track.run(trackAction)
        
        return track
        
    }
    
    func switchImage(newImage imageName:String) {
        sprite!.texture = SKTexture(imageNamed: imageName)
    }
    
    func drawImage() {
        sprite!.texture = SKTexture(imageNamed: drawTrack())
    }
    
    func drawTrack() -> String {
        let opt = arc4random_uniform(100);
        
        if(opt <= 50) {
            type = "n"
            return "track"
        }
        
        type = "b"
        return "track_broken"
    }
    
    func createRepairButton() -> SKSpriteNode? {
        if(type == "b"){
            let repairButton = SKSpriteNode(imageNamed: "repair_button")
            
            repairButton.name = "repair_button"
            repairButton.xScale = 1.3
            repairButton.yScale = 1.3
            
            repairButton.position = CGPoint(x: -repairButton.size.width + 150, y: sprite!.position.y + sprite!.size.height/4)
            
            let repairAction = SKAction.repeatForever(               //Track movement
                SKAction.moveBy(x: 0.0,
                                y: -speed,
                                duration: 1.0)
            )
            
            repairButton.run(repairAction)
            
            return repairButton
        }
        
        return nil
    }
}

