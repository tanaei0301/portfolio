import UIKit

class settingViewController: UIViewController,  UIPickerViewDelegate,  UIPickerViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var userLibraryButton: UIButton!
    @IBOutlet weak var urlTranscriptionSwich: UISwitch!
    
    let picker = UIPickerView()
    let fileController = FileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.delegate = self
        self.picker.dataSource = self
        
        let nowLanguage = fileController.loadLanguageValue()["name"]!
        let nowLangIndex = {() -> Int in
            for (index , country) in self.languageList.enumerated(){
                if country["name"] == nowLanguage{
                    return index
                }
            }
            return 0
        }
        urlTranscriptionSwich.isOn = UserDefaults.standard.bool(forKey: "transcriptUrlRequestIsOn")
        languageTextField.delegate = self
        languageTextField.inputView = picker
        languageTextField.text = nowLanguage
        
        self.picker.selectRow(nowLangIndex(), inComponent: 0, animated: false)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func switchURLTranscriptIsOn(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "transcriptUrlRequestIsOn")
    }
    
    @IBAction func moveUserDictionary(_ sender: Any) {
    }
    let languageList = [
        [
            "name" : "日本語",
            "code" : "ja-JP",
        ],
        [
            "name" : "英語",
            "code" : "en-UK",
        ],
        [
            "name" : "韓国語",
            "code" : "ko-KR",
        ],
        [
            "name" : "中国語(繁体字)",
            "code" : "zh-TW",
        ],
        [
            "name" : "中国語(簡体字)",
            "code" : "zh-CN",
        ],
        [
            "name" : "フランス語",
            "code" : "fe-FR",
        ],
        [
            "name" : "イタリア語",
            "code" : "it-IT",
        ],
        [
            "name" : "オランダ語",
            "code" : "nl-NL",
        ],
        [
            "name" : "スペイン語",
            "code" : "es=ES",
        ],
        [
            "name" : "スペイン語(メキシコ)",
            "code" : "es-MX",
        ],
        [
            "name" : "ロシア語",
            "code" : "ru-RU",
        ],
        [
            "name" : "ウクライナ語",
            "code" : "uk-UA",
        ],
        [
            "name" : "ドイツ語",
            "code" : "de-DE",
        ],
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageList[row]["name"]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageTextField.text = languageList[row]["name"]
        fileController.saveLanguageValue(languData: languageList[row])
    }
}
