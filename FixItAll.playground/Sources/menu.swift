import PlaygroundSupport
import SpriteKit
import AVFoundation

public class MainMenu : SKScene {
    
    var audioPlayer:AVAudioPlayer? = nil
    var started = false
    
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
        
        if(started == false && node.name == "play_button"){
            started = true
            
            if let scene = GameScene(fileNamed: "GameScene") {
                playSound(file: "train_whistle", ext: "mp3")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    scene.scaleMode = .aspectFit
                    
                    self.view!.presentScene(scene)
                }
                
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
}
