import UIKit
import Photos

class LookBackViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recognitionTextView: UITextView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var imageArea: UIImageView!
    
    let picker = UIImagePickerController()
    let fileController = FileController()
    var fileIndex:Int?
    var fileName:String?
    let audioController = Audio_Controller()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = fileName
        self.timeLabel.text = fileController.fileUpDate(fileName: fileName!, directName: nil, UDT: false) as? String
        self.recognitionTextView.text = fileController.open_file(fileName: "recognitionData.txt", directName: fileName!)
        navigationController?.delegate = self
        picker.delegate = self
        var imageData = fileController.loadImageFile(directName: fileName!)
        if imageData == nil{
            imageData = UIImage(named: "NoImage")
        }
        imageArea.image = imageData
    }
    
    @IBAction func rePlayAudio(_ sender: Any) {
        let documentPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let Paths = documentPaths.appendingPathComponent(fileName!)
        let audioPath = Paths.appendingPathComponent("audio.m4a")
        
        audioController.playAudioFile(filePath:audioPath)
    }
    
    @IBAction func eraseThisFile(_ sender: Any) {
        var alert = UIAlertController(title: "消去します", message: "消去されたデータは二度と復元できません", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "OK", style: .destructive, handler:{
            (action: UIAlertAction!) -> Void in
            guard self.fileController.removeDirect(removeDirectName: self.fileName!) else{
                alert = UIAlertController(title: "エラー", message: "ディレクトリの消去に失敗しました", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.navigationController?.popViewController(animated: true)
        })
        let canselAction = UIAlertAction(title: "キャンセル", style: .default)
        
        alert.addAction(canselAction)
        alert.addAction(continueAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapImage(_ sender: Any) {
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let preImage = info[.originalImage] as? UIImage else{
            print("ImageNotFound")
            return
        }
        self.imageArea.image = preImage
        guard fileController.saveImageFile(directName: fileName!, image: preImage) else{
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func joinPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        else{
            print("Photo Library not acailable")
        }
    }
}
