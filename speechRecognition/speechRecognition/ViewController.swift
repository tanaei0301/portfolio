//
//  ViewController.swift
//  speechRecognition
//
//  Created by Taichi Tanaka on 2022/12/16.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    let getDateTime = GetDateTime()
    
    let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var finalTranscript : String?
    let fileController = FileController()
    let audioEngine = AVAudioEngine()
    var inputNode:AVAudioInputNode?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var speechRecognizer:SFSpeechRecognizer!
    var audioSession:AVAudioSession?
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    let session = AVAudioSession.sharedInstance()
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.register(defaults: ["languageCode" : ["name":"日本語","code":"ja-JP"]])
        
        button2.isHidden = true
        button2.isEnabled = false
        
        
        textView1.layer.borderColor = UIColor.gray.cgColor
        textView1.layer.borderWidth = 2.0
        textView1.layer.cornerRadius = 15.0
        textView1.layer.masksToBounds = true
        textView1.font = UIFont.systemFont(ofSize: 17)
        
        textView2.layer.borderColor = UIColor.gray.cgColor
        textView2.layer.borderWidth = 2.0
        textView2.layer.cornerRadius = 15.0
        textView2.layer.masksToBounds = true
        
        indicator.style = .large
        indicator.center = self.textView2.center
        indicator.color = UIColor.gray
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        self.button3.isEnabled = false
        speechrecognitionPermission()
    }
    
    @IBAction func startRecognition(_ sender: Any) {
        startRecoding()
        specchrecognition()
        
        self.button1.isEnabled = false
        self.button1.isHidden = true
        self.button2.isEnabled = true
        self.button2.isHidden = false
        
    }
    
    @IBAction func stopRecognition(_ sender: Any) {
        self.button1.isEnabled = true
        self.button1.isHidden = false
        self.button2.isEnabled = false
        self.button2.isHidden = true
        
        stopRecognitionTask()
        stopRecoding()
        
        if UserDefaults.standard.bool(forKey: "transcriptUrlRequestIsOn"){
            self.indicator.startAnimating()
            finalTranscript = recognitionUrlRequest()
        }
        else{
            self.button3.isEnabled = true
        }
        self.button3.isEnabled = true
        self.textView2.text = finalTranscript
    }
    
    //データを保存するページに移動
    @IBAction func movePage(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SaveView") as! SaveViewController
        nextVC.recognitionData = self.textView2.text
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //データの一覧を表示するページに移動
    @IBAction func open_fileView(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "selectFilePage") as! selectFilePageViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

    func speechrecognitionPermission(){
        SFSpeechRecognizer.requestAuthorization { SFSpeechRecognizerAuthorizationStatus in
            OperationQueue.main.addOperation {
                if SFSpeechRecognizerAuthorizationStatus == .authorized{
                    self.button1.isEnabled = true
                }
                else{
                    let alert = UIAlertController(title: "エラー", message: "マイクの使用を許可してください", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    self.button1.isEnabled = false
                }
            }
        }
    }
    

    func specchrecognition(){
        print("startRecognition")
        inputNode = audioEngine.inputNode
        audioSession = AVAudioSession.sharedInstance()
        
        try? audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: FileController().loadLanguageValue()["code"]!))
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.textView1.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                print("Text \(result.bestTranscription.formattedString)")
                if(isFinal == true){
                    self.textView2.text.append(result.bestTranscription.formattedString)
                }
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                self.inputNode?.removeTap(onBus: 0)
                print("recognitionStop")
            }
        }
    }
    
    func stopRecognitionTask(){
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest?.endAudio()
    }
    
    func recognitionUrlRequest() -> String?{
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: FileController().loadLanguageValue()["code"]!))
        let request = SFSpeechURLRecognitionRequest(url: fileController.forAudioUrlPath())
        var resultTranscript = ""
        speechRecognizer.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                print(error as Any)
                self.indicator.stopAnimating()
                return
            }
            
            if result.isFinal {
                print("Speech in the file is \(result.bestTranscription.formattedString)")
                self.textView2.text = result.bestTranscription.formattedString
                resultTranscript = result.bestTranscription.formattedString
                self.button3.isEnabled = true
            }
        }
        self.indicator.stopAnimating()
        return resultTranscript
    }
    
    func startRecoding(){
        try! session.setCategory(.playAndRecord)
        try! session.setActive(true)
        audioRecorder = try! AVAudioRecorder(url: fileController.forAudioUrlPath(), settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        print("startRecoding")
    }
    
    func stopRecoding(){
        audioRecorder.stop()
        print("stopRecoding")
    }
}
