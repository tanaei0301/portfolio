//
//  userDictionarySettingViewController.swift
//  speechRecognition
//
//  Created by Taichi Tanaka on 2023/01/17.
//

import UIKit

class userDictionarySettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var dictionaryTable: UITableView!
    @IBOutlet weak var addCellButton: UIButton!
    
    
    var userDefaults = UserDefaults.standard
    var dictinaryList = [""]
    var cellQuantity:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dictionaryTable.delegate = self
        self.dictionaryTable.dataSource = self
        cellQuantity = dictinaryList.count
    }
    
    @IBAction func addCell(_ sender: Any) {
        cellQuantity += 1
        self.dictionaryTable.reloadData()
    }
    
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellQuantity
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell",for: indexPath)
        
        let lavel1 = cell.viewWithTag(1) as! UILabel
        lavel1.text = String(indexPath.row)
        
        let textField = cell.viewWithTag(2) as! UITextField
        textField.text = dictinaryList[indexPath.row]
        
        return cell
    }
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
    }
    
}
