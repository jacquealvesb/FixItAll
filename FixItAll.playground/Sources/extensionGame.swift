import PlaygroundSupport
import SpriteKit
import AppKit
import AVFoundation

let LEFT_ARROW = 123
let RIGHT_ARROW = 124
let DOWN_ARROW = 125
let UP_ARROW = 126

public class GameScene : SKScene {

    var currentTrack:Track? = nil
    var nextTrack:Track? = nil
    
    let text = SKLabelNode(fontNamed: "Arial")
    let repairFeedback = SKSpriteNode(imageNamed: "repair_feedback [notfixed-0]")
    let repairFeedbackRotate = SKSpriteNode(imageNamed: "repair_feedback [notfixed-1]")
    
    var arrowButtons:[SKSpriteNode] = []
    var currentArrow = 0
    var showingArrows = false                                           //Checks if the player is fixing a track
    
    var fixStatus:SKSpriteNode? = nil                                   //Fixing status bar
    var fixStatusBack:SKSpriteNode? = nil
    var fixIcon:SKSpriteNode? = nil
    let maxFixStatusWidth:CGFloat = 250.0
    var maxSpins:CGFloat = 3.0                                          //Number of sequence to complete to fix a track
    var currentSpins:CGFloat = 0.0
    var normalTracks = 3                                                //Checks if 3 normal tracks were showed in a roll
    
    var distance:Float = 0.0
    var timer:Timer? = nil
    
    var audioPlayer:AVAudioPlayer? = nil
    
    public override func didMove (to view: SKView) {
        self.backgroundColor = NSColor(red: 0.43, green: 0.17, blue: 0.0, alpha: 1.0)
        
        self.createArrowButtons()
        
        currentTrack = Track(name: "track1",
                             initialSpeed: 100.0,
                             initialY: 0.0,
                             type: "n")                                 //Creates the first track to be shown
        
        self.addChild(currentTrack!.sprite!)
        
        nextTrack = Track(name: "track2",
                          initialSpeed: 100.0,
                          initialY: (scene?.size.height)! + 10.0,
                          type: "b")                                    //Creates the track that's going to be on the top of the screen
        
        
        self.addChild(nextTrack!.sprite!)
        self.addChild(nextTrack!.repairButton!)
        
        self.testLabel()
        self.createTrain()
        self.createFixStatus()
        self.createRepairFeedback()
        
        timer = Timer.scheduledTimer(timeInterval: Double(currentTrack!.speed/100), target: self, selector: #selector(updateDistance), userInfo: nil, repeats: true)
        
        playSound(file: "train_sound", ext: "mp3")
    }

    public override func update(_ currentTime: TimeInterval) {

        if(currentTrack!.sprite!.position.y <= -(scene?.size.height)!) {//Checks if the current track is not visible on the screen anymore
            if(currentTrack!.type != "n"){                              //Checks if a broken track has reached the end of the scene
                if let gameOver = GameOver(fileNamed: "GameOver") {
                    if let player = audioPlayer {
                        player.stop()
                        playSound(file: "train_crash", ext: "mp3")
                    }
                    saveDistance ()                                     //Saves reached distance
                    gameOver.scaleMode = .aspectFit
                    
                    view!.presentScene(gameOver)
                }
            } else {
                let trackAux = currentTrack                             //Switches the current and next tracks
                currentTrack = nextTrack
                nextTrack = trackAux
                
                if(showingArrows == false){                             //Checks if the player is fixing a track
                    nextTrack!.drawImage()                              //Draws the type and image of the next track
                } else {
                    nextTrack!.switchImage(newImage: "track")
                }
                nextTrack!.resetPosition(scene: scene!)                 //Sets its position to the top of the screen
                nextTrack!.repairButton!.removeFromParent()
                
                if(nextTrack!.type != "n"){                             //Checks if the next track is broken or not
                    if(showingArrows == false){                         //Checks if the player is fixing a track
                        showingArrows = true
                        self.addChild(nextTrack!.repairButton!)
                    }
                    
                    normalTracks = 3
                } else {
                    normalTracks -= 1
                    if(normalTracks == 0 && showingArrows == false){    //Checks if 3 normal tracks in a roll were showned
                        nextTrack!.switchImage(newImage: "track_broken")
                        
                        showingArrows = true
                        self.addChild(nextTrack!.repairButton!)
                        
                        normalTracks = 3
                    }
                }
                
            }
        }
    }
    
    @objc func updateDistance() {
        distance += 0.5
        text.text = "\(distance)m"
    }
    
    public override func mouseDown(with: NSEvent) {
        let location = with.location(in: self)
        let node = self.atPoint(location)
        
        if (node.name == "repair_button") {                         //Checks if the repair button was clicked
            node.removeFromParent()                                 //Removes repair button from scene
            showButtonArrows()                                      //Shows the arrow buttons
            
            self.addChild(fixStatusBack!)
            self.addChild(fixIcon!)
        }
    }
    
    public override func keyDown(with event: NSEvent) {             //Checks if the player has pressed a arrow keyboard button
        switch Int(event.keyCode) {
            case LEFT_ARROW:
                checkArrowPress(0)
                break
            case UP_ARROW:
                checkArrowPress(1)
            break
            case RIGHT_ARROW:
                checkArrowPress(2)
            break
            case DOWN_ARROW:
                checkArrowPress(3)
                break
            default:
            break
        }
    }
    
    func playSound(file:String, ext:String) -> Void {
        let url = Bundle.main.url(forResource: file, withExtension: ext)!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /*-------------------------------UI-------------------------------*/
    
    func createFixStatus(){
        fixStatusBack = SKSpriteNode(color:NSColor(red: 0.4, green: 0.17, blue: 0.16, alpha: 1.0), size: CGSize(width: maxFixStatusWidth + 20, height: 50))
        
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
        
        self.addChild(fixStatus!)
        
    }
    
    func testLabel () {
        text.fontSize = 40
        text.fontColor = SKColor.white
        text.position = CGPoint(x: -(scene!.size.width)/2 + 80, y: (scene!.size.width)/2 - 200)
        text.zPosition = 4
        
        text.text = "0.0m"
        
        addChild(text)
    }
    
    func createArrowButtons() {
        
        for i in 0...3 {
            let button = SKSpriteNode(imageNamed: "arrow_button")
            
            
            switch(i){
            case 0:
                button.name = "left"
                button.position = CGPoint(x: (scene?.size.width)!/3 - 100, y: -220)
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
                text.text = "erro"
                break
            }
            
            button.xScale = 1.3
            button.yScale = 1.3
            
            arrowButtons.append(button)
            
        }
        
    }
    
    func createRepairFeedback(){
        repairFeedback.xScale = 1.3
        repairFeedback.yScale = 1.3
        
        repairFeedback.position = CGPoint(x: (scene!.size.width)/2 - 180, y: (scene!.size.width)/2 - 280)
        
        repairFeedbackRotate.xScale = 1.3
        repairFeedbackRotate.yScale = 1.3
        
        repairFeedbackRotate.position = CGPoint(x: (scene!.size.width)/2 - 122, y: (scene!.size.width)/2 - 218)
        repairFeedbackRotate.anchorPoint = CGPoint(x: 0.2, y: 0.8)
        
        let repairFeedbackAction = SKAction.repeatForever(
              SKAction.rotate(byAngle: -CGFloat.pi, duration: 1)
        )
        
        repairFeedbackRotate.run(repairFeedbackAction)
        
    }
    
    public func saveDistance (){
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(distance, forKey: "distance")
        userDefaults.synchronize()
    }
    
    /*-------------------------------Tracks and train-------------------------------*/
    
    func createTrain(){
        let train = SKSpriteNode(imageNamed: "train")
        
        train.name = "train"
        
        train.xScale = 1.3
        train.yScale = 1.3
        train.zPosition = 4
        
        let trainSequence = SKAction.sequence(  [SKAction.scale(to: 1.35, duration: 0.5),
                                                SKAction.scale(to: 1.3, duration: 0.5)])
        
        train.run(SKAction.repeatForever(trainSequence))
        
        train.position = CGPoint(x: 0.0, y: -(scene?.size.height)!/4 - train.size.height)

        self.addChild(train)
    }
    
    func fixTrack(){
        for arrow in arrowButtons {                                 //Removes all arrows from the scene
            arrow.removeFromParent()
        }
        
        if(currentTrack!.type != "n"){
            currentTrack!.switchImage(newImage: "track")            //Changes the track's image
            currentTrack!.type = "n"                                //Resets the track's type
        } else if(nextTrack!.type != "n") {
            nextTrack!.switchImage(newImage: "track")               //Changes the track's image
            nextTrack!.type = "n"                                   //Resets the track's type
        }
        
        currentTrack!.addSpeed(40)                                  //Increases speed
        nextTrack!.addSpeed(40)
        
        currentSpins = 0.0
        showingArrows = false
        
        repairFeedback.removeFromParent()
        repairFeedbackRotate.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //Hides the fix status from the scene in 2 seconds
            self.fixStatus!.size.width = 0.0
            self.fixStatusBack!.removeFromParent()
            self.fixIcon!.removeFromParent()
        }
    }
    
    /*-------------------------------Arrow Buttons-------------------------------*/
    
    func showButtonArrows(){
        for arrow in arrowButtons {
            arrow.texture = SKTexture(imageNamed: "arrow_button")   //Resets the texture of the arrow
            self.addChild(arrow)
        }
        
        arrowButtons[0].texture = SKTexture(imageNamed: "arrowHighlighted_button")
        
        self.addChild(repairFeedback)
        self.addChild(repairFeedbackRotate)
    }
    
    func checkArrowPress(_ pressedArrow:Int){
        arrowButtons[currentArrow].texture = SKTexture(imageNamed: "arrow_button")  //Resets pressed arrow texture
        
        if(pressedArrow == currentArrow){                           //Checks if the right arrow was pressed
            if(currentArrow == 3){                                  //Checks if the whole sequence was completed
                currentArrow = 0
                currentSpins += 1
                fixStatus!.size.width += maxFixStatusWidth/maxSpins //Increases fixing bar
                
            } else {
                currentArrow += 1
            }
            
        } else {
            currentArrow = 0
        }
        arrowButtons[currentArrow].texture = SKTexture(imageNamed: "arrowHighlighted_button")//Shows the next arrow to press
        
        if(currentSpins == maxSpins){                               //Checks if the seqence was completed 'n' times
            fixTrack()
        }
    }
 
}
