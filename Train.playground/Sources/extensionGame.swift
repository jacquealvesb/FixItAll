import PlaygroundSupport
import SpriteKit
import AppKit

let LEFT_ARROW = 123
let RIGHT_ARROW = 124
let DOWN_ARROW = 125
let UP_ARROW = 126

public class GameScene : SKScene {
    let text = SKLabelNode(fontNamed: "Arial")
    var currentTrack:Track? = nil
    var nextTrack:Track? = nil
    
    var arrowButtons:[SKSpriteNode] = []
    var arrowButtonsID:[String:Int] = [:] //0: Lelf, 1: Up, 2: Right, 3: Down
    var currentArrow = 0
        
    public override func didMove (to view: SKView) {
        self.backgroundColor = NSColor(red: 0.43, green: 0.17, blue: 0.0, alpha: 1.0)
        
        self.createArrowButtons()
        
        currentTrack = Track(name: "track1",
                             initialSpeed: 200.0,
                             initialY: 0.0)                 //Creates the first track to be shown
        
        nextTrack = Track(name: "track2",
                          initialSpeed: 200.0,
                          initialY: (scene?.size.height)! + 10.0)  //Creates the track that's going to be on the top of the screen
        
        self.addChild(currentTrack!.sprite!)
        self.addChild(nextTrack!.sprite!)
        
        self.testLabel()
        
        self.createTrain()
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if(currentTrack!.sprite!.position.y <= -(scene?.size.height)!) {    //Checks if the current track is not visible on the screen anymore
            let trackAux = currentTrack                                     //Switches the current and next tracks
            currentTrack = nextTrack
            nextTrack = trackAux
            
            nextTrack!.drawImage()                                          //Draws the type and image of the next track
            nextTrack!.sprite!.position.y = (scene?.size.height)! + 10.0           //Sets its position to the top of the screen
            
            if(nextTrack!.type != "n"){
                if let repairButton = nextTrack!.createRepairButton() {
                    self.addChild(repairButton)
                }
                
            }
        }
    }
    
    public override func mouseDown(with: NSEvent) {
        // Get mouse position in scene coordinates
        let location = with.location(in: self)
        // Get node at mouse position
        let node = self.atPoint(location)
        if (node.name == "repair_button") {
            text.text = "clicou"
        }
    }
    
    public override func keyDown(with event: NSEvent) {                     //Checks if the player has pressed a arrow keyboard button
        switch Int(event.keyCode) {
            case LEFT_ARROW:
                text.text = "esquerda"
                break
            case RIGHT_ARROW:
                text.text = "direita"
            break
            case UP_ARROW:
                text.text = "cima"
            break
            case DOWN_ARROW:
                text.text = "baixo"
                break
            default:
            break
        }
    }
    
    func createTrain(){
        let train = SKSpriteNode(imageNamed: "train")
        
        train.name = "train"
        
        train.xScale = 1.3
        train.yScale = 1.3
        
        //train.size.height - (scene?.size.height)!/2
        
        train.position = CGPoint(x: 0.0, y: -(scene?.size.height)!/4 - train.size.height)

        self.addChild(train)
    }
    
    func createArrowButtons() {
        let button = SKSpriteNode(imageNamed: "arrow_button")
        button.name = "up"
        
        button.position = CGPoint(x: (scene?.size.width)!/3, y: -200)
        
        button.xScale = 1.3
        button.yScale = 1.3
        
        arrowButtons.append(button)
        arrowButtonsID[button.name!] = 0
        
        self.addChild(button)
    }
    
    
    func testLabel () {
        text.fontSize = 40
        text.fontColor = SKColor.white
        text.position = CGPoint(x: 0, y: 0)
        
        addChild(text)
    }
    
}
