import Foundation
import AVFoundation

class Audio_Controller: ViewController{
    var audioPlayer = AVAudioPlayer()
    
    func preplayAudioFile(){
        audioPlayer = try! AVAudioPlayer(contentsOf: fileController.forAudioUrlPath())
        audioPlayer.delegate = self
        audioPlayer.play()
    }
    
    func playAudioFile(filePath:URL){
        audioPlayer = try! AVAudioPlayer(contentsOf: filePath)
        audioPlayer.delegate = self
        audioPlayer.play()
    }
}
