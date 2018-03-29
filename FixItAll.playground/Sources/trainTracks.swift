import PlaygroundSupport
import SpriteKit

public class Track {
    var name:String
    var speed:CGFloat
    
    var sprite:SKSpriteNode? = nil
    var repairButton:SKSpriteNode? = nil
    var type: String = ""                                       //Either a normal track or a broken one
    var fixed:Bool = false
    
    init (name:String, initialSpeed:CGFloat, initialY:CGFloat, type:String) {                      //Sets the name of the track and creates its sprite
        self.name = name
        self.speed = initialSpeed
        self.type = type
        
        sprite = createTrack(atY: initialY)
        if(self.type != "n"){
            self.switchImage(newImage: "track_broken")
        }
        
        repairButton = createRepairButton()
    }
    
    func createTrack(atY y:CGFloat) -> SKSpriteNode {           //Creates the sprite of the track
        let track = SKSpriteNode(imageNamed: "track")
        
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
    
    func addSpeed(_ speed:CGFloat) {
        sprite!.removeAllActions()
        repairButton!.removeAllActions()
        
        self.speed += speed
        
        let trackAction = SKAction.repeatForever(               //Track movement
            SKAction.moveBy(x: 0.0,
                            y: -self.speed,
                            duration: 1.0)
        )
        
        let repairAction = SKAction.repeatForever(               //Track movement
            SKAction.moveBy(x: 0.0,
                            y: -self.speed,
                            duration: 1.0)
        )
        
        repairButton!.run(repairAction)
        sprite!.run(trackAction)
    }
    
    func switchImage(newImage imageName:String) {
        sprite!.texture = SKTexture(imageNamed: imageName)
        if(imageName == "track"){
            type = "n"
        } else {
            type = "b"
        }
    }
    
    func drawImage() {
        switchImage(newImage: drawTrack())
    }
    
    func drawTrack() -> String {
        let opt = arc4random_uniform(100);
        
        if(opt <= 50) {
            return "track"
        }
        
        return "track_broken"
    }
    
    func createRepairButton() -> SKSpriteNode? {
        let repairButton = SKSpriteNode(imageNamed: "repair_button")
        
        repairButton.name = "repair_button"
        repairButton.xScale = 1.3
        repairButton.yScale = 1.3
        
        
        repairButton.position = CGPoint(x: -repairButton.size.width + 150, y: sprite!.position.y + sprite!.size.height/4)
        repairButton.zPosition = 3
        
        let repairAction = SKAction.repeatForever(               //Track movement
            SKAction.moveBy(x: 0.0,
                            y: -speed,
                            duration: 1.0)
        )
        
        repairButton.run(repairAction)
        
        self.repairButton = repairButton
        
        return repairButton
       
    }
    
    func resetPosition(scene:SKScene){
        self.sprite!.position.y = scene.size.height + 11.0
        self.repairButton!.position = CGPoint(x: -repairButton!.size.width + 150, y: sprite!.position.y + sprite!.size.height/4)
        
    }
}

