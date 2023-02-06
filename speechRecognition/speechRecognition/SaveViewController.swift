//
//  SaveViewController.swift
//  speechRecognition
//
//  Created by Taichi Tanaka on 2022/12/16.
//

import UIKit
import Photos

class SaveViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var titleTextArea: UITextField!
    @IBOutlet weak var dayTimeTextArea: UITextField!
    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var audioPreviewButton: UIButton!
    @IBOutlet weak var clearImageButton: UIButton!
    
    
    let getDateTime = GetDateTime()
    var recognitionData : String?
    var dateData : String?
    var day_of_weekData : String?
    let fileController = FileController()
    var directTitle = ""
    var createFileTime : String?
    var brackboardImage:Any?
    let audioController = Audio_Controller()
    let picker = UIImagePickerController()
    var image:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearImageButton.isHidden = true
        self.clearImageButton.isEnabled = false
        picker.delegate = self
        self.imageView.image = UIImage(named: "tapToPicture")
        dateData = getDateTime.getDateData()
        day_of_weekData = getDateTime.day_of_week(setting : "ja_JP")
        
        //self.titleTextArea.addTarget(self, action: #selector(titleTextAreaChecker),for: .editingChanged)
        createFileTime = dateData! + day_of_weekData!
        self.dayTimeTextArea.text = dateData! + day_of_weekData!
        self.previewTextView.text = recognitionData
    }
    
    @IBAction func saveData(_ sender: Any) {
        titleTextAreaChecker()
        if directTitle != "" || recognitionData != nil{
            guard fileController.create_Direct(directName: directTitle) else{
                let alert = UIAlertController(title: "エラー", message: "ディレクトリの作成に失敗しました", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard fileController.savetext_File(directName: directTitle, FileName: "recognitionData" ,data: self.previewTextView.text) else{
                let alert = UIAlertController(title: "エラー", message: "テキストデータの保存に失敗しました", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                for _ in 0 ..< 3{
                    if fileController.removeDirect(removeDirectName: directTitle){
                        break
                    }
                    else{
                        print("不完全なファイルの消去に失敗しました。")
                    }
                }
                return
            }
            
            if image != nil{
                guard fileController.saveImageFile(directName: directTitle, image: image!) else{
                    let alert = UIAlertController(title: "エラー", message: "画像の保存に失敗しました。画像がjpegデータであることを確認してください。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    for _ in 0 ..< 3{
                        if fileController.removeDirect(removeDirectName: directTitle){
                            break
                        }
                        else{
                            print("不完全なファイルの消去に失敗しました。")
                        }
                    }
                    return
                }
            }
            
            if fileController.audioFileSave(directName: directTitle) == false{
                let alert = UIAlertController(title: "エラー", message: "音声ファイルの保存に失敗しました", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func titleTextAreaChecker(){
        let tempTitle = self.titleTextArea.text
        let titleisEnabled = fileController.newFileNameChecker(checkFileName: tempTitle)
        if titleisEnabled == false{
            let alert = UIAlertController(title: "その名前は使用できません", message: "その名前は使用できません。別のものに変更してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            directTitle = tempTitle!
        }
    }
    
    @IBAction func saveAudioPreview(_ sender: Any) {
        audioController.preplayAudioFile()
    }
    
    @IBAction func tapImage(_ sender: Any) {
        joinPhotoLibrary()
    }
    
    @IBAction func clearImage(_ sender: Any) {
        image = nil
        self.imageView.image = UIImage(named: "tapToPicture")
        self.clearImageButton.isHidden = true
        self.clearImageButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let preImage = info[.originalImage] as? UIImage else{
            print("ImageNotFound")
            return
        }
        image = preImage
        self.imageView.image = preImage
        
        self.clearImageButton.isHidden = false
        self.clearImageButton.isEnabled = true
        // UIImagePickerController カメラが閉じる
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
