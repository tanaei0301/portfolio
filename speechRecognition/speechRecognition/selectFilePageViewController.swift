import UIKit

class selectFilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let fileController = FileController()
    var fileList = [String]()
    var removeFileFlag:Bool?
    
    @IBOutlet weak var table1: UITableView!
    
    //ページが読み込まれた時に実行される。ページバックでは実行されない
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //ページバック時にも実行される。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table1.reloadData()
    }
    
    //Table Viewのセルの数を指定
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fileCount:Optional = fileController.fileCounter()
        return fileCount!
    }
    
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell",for: indexPath)
        fileList = fileController.searchFile()!
        let fileUpDate = fileController.fileUpDate(fileName: fileList[indexPath.row], directName: nil, UDT: false)
        var preImage = fileController.loadImageFile(directName: fileList[indexPath.row])
        if preImage == nil {
            preImage = UIImage(named: "NoImage")
        }
        
        let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = preImage
        
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = fileList[indexPath.row]
        
        let label2 = cell.viewWithTag(3) as! UILabel
        label2.text = fileUpDate as? String
        
        return cell
    }
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)番目の行が選択されました。")
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LookBackView") as! LookBackViewController
        nextVC.fileName = fileList[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
