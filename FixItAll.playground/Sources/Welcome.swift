import PlaygroundSupport
import SpriteKit

public class Welcome : SKScene {
    var track:SKSpriteNode? = nil
    var repairButton:SKSpriteNode? = nil
    var playButton:SKSpriteNode? = nil
    
    var fixStatus:SKSpriteNode? = nil                                   //Fixing status bar
    var fixStatusBack:SKSpriteNode? = nil
    var fixIcon:SKSpriteNode? = nil
    
    var arrowButtons:[SKSpriteNode] = []
    var currentArrow = 0
    var currentSpins = 0
    
    let scaleSequence = SKAction.sequence(  [SKAction.scale(to: 1.35, duration: 0.5),
                                             SKAction.scale(to: 1.3, duration: 0.5)])
    
    public override func didMove(to view: SKView){
        self.backgroundColor = NSColor(red: 0.43, green: 0.17, blue: 0.0, alpha: 1.0)
        
        track = createSprite(imageName: "track_broken", at: CGPoint(x: -40, y: 0), scale: 1.3)
        let train = createSprite(imageName: "train", at: CGPoint(x: 0.0, y: -(scene?.size.height)!/4 - 150), scale: 1.3)
        repairButton = createSprite(imageName: "repair_button", at: CGPoint(x: -250, y: track!.position.y + track!.size.height/4), scale: 1.3)
        
        train.run(SKAction.repeatForever(scaleSequence))
        repairButton!.run(SKAction.repeatForever(scaleSequence))
        
        playButton = createSprite(imageName: "play_button", at: CGPoint(x: 350, y: -230), scale: 1.5)
        
        self.addChild(track!)
        self.addChild(train)
        self.addChild(repairButton!)
    }
    
    public override func mouseDown(with: NSEvent) {
        let location = with.location(in: self)
        let node = self.atPoint(location)
        
        if(node.name == "repair_button"){
            repairButton!.removeFromParent()
            createArrowButtons()
            createFixStatus()
        } else if (node.name == "play_button") {
            if let scene = MainMenu(fileNamed: "MainMenu") {
                scene.scaleMode = .aspectFit
                    
                self.view!.presentScene(scene)
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
    
    func createArrowButtons() {
        
        for i in 0...3 {
            let button = SKSpriteNode(imageNamed: "arrow_button")
            
            switch(i){
            case 0:
                button.name = "left"
                button.position = CGPoint(x: (scene?.size.width)!/3 - 100, y: -220)
                button.texture = SKTexture(imageNamed: "arrowHighlighted_button")
                
                button.run(SKAction.repeatForever(scaleSequence))
                break
            case 1:
                button.name = "up"
                button.zRotation = -CGFloat(Double.pi/2)
                button.position = CGPoint(x: (scene?.size.width)!/3, y: -130)
                break
            case 2:
                button.name = "right"
                button.zRotation = CGFloat(Double.pi)
                button.position = CGPoint(x: (scene?.size.width)!/3 + 100, y: -220)
                break
            case 3:
                button.name = "down"
                button.zRotation = CGFloat(Double.pi/2)
                button.position = CGPoint(x: (scene?.size.width)!/3, y: -320)
                break
            default:
                break
            }
            
            button.xScale = 1.3
            button.yScale = 1.3
            
            arrowButtons.append(button)
            self.addChild(button)
        }
        
    }
    
    func createFixStatus(){
        fixStatusBack = SKSpriteNode(color:NSColor(red: 0.4, green: 0.17, blue: 0.16, alpha: 1.0), size: CGSize(width: 270, height: 50))
        
        fixStatusBack!.position = CGPoint(x: -(scene!.size.width)/2 + 40, y: -(scene!.size.height)/2 + 50)
        fixStatusBack!.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        fixStatusBack!.zPosition = 4
        
        fixStatus = SKSpriteNode(color:NSColor(red: 0.98, green: 0.63, blue: 0.17, alpha: 1.0), size: CGSize(width: 0, height: 30))
        
        fixStatus!.position = CGPoint(x: -(scene!.size.width)/2 + 50, y: -(scene!.size.height)/2 + 50)
        fixStatus!.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        fixStatus!.zPosition = 5
        
        fixIcon = SKSpriteNode(imageNamed: "repair_feedback [notfixed-1]")
        
        fixIcon!.xScale = 0.3
        fixIcon!.yScale = 0.3
        
        fixIcon!.position = CGPoint(x: -(scene!.size.width)/2 + 20, y: -(scene!.size.height)/2 + 50)
        fixIcon!.zPosition = 4
        
        self.addChild(fixStatusBack!)
        self.addChild(fixStatus!)
        self.addChild(fixIcon!)
        
    }
    
    public override func keyDown(with event: NSEvent) {             //Checks if the player has pressed a arrow keyboard button
        switch Int(event.keyCode) {
        case 123:
            checkArrowPress(0)
            arrowButtons[0].removeAllActions()
            break
        case 126:
            checkArrowPress(1)
            break
        case 124:
            checkArrowPress(2)
            break
        case 125:
            checkArrowPress(3)
            break
        default:
            break
        }
    }
    
    func checkArrowPress(_ pressedArrow:Int){
        arrowButtons[currentArrow].texture = SKTexture(imageNamed: "arrow_button")  //Resets pressed arrow texture
        
        if(pressedArrow == currentArrow){                           //Checks if the right arrow was pressed
            if(currentArrow == 3){                                  //Checks if the whole sequence was completed
                currentArrow = 0
                currentSpins += 1
                fixStatus!.size.width += 250/3                      //Increases fixing bar
                
            } else {
                currentArrow += 1
            }
            
        }
        arrowButtons[currentArrow].texture = SKTexture(imageNamed: "arrowHighlighted_button")//Shows the next arrow to press
        
        if(currentSpins == 3){                                      //Checks if the seqence was completed 'n' times
            for arrow in arrowButtons {
                arrow.removeFromParent()
            }
            
            track!.texture = SKTexture(imageNamed: "track")
            fixStatusBack!.removeFromParent()
            fixStatus!.removeFromParent()
            fixIcon!.removeFromParent()
            
            let check = createSprite(imageName: "check", at: CGPoint(x: 300, y: 200), scale: 0.5)
            
            self.addChild(check)
            self.addChild(playButton!)
        }
    }
    
}
