import UIKit

class FileController{
    let fileManager = FileManager()
    let documentPaths = try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let getDateTime = GetDateTime()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func searchFile()-> (Array<String>)?{
        let urls = documentPaths[0]
        print(urls.path)
        guard var fileNames = try? FileManager.default.contentsOfDirectory(atPath: urls.path) else {
            return nil
        }
        fileNames.removeAll(where: {$0 == ".DS_Store"})
        for (index, country) in fileNames.enumerated().reversed(){
            if country.contains(".m4a") || country.contains(".txt"){
                fileNames.remove(at: index)
            }
        }
        //取得したファイルを作成日時が近い順に並び替える　バブルソート
        var aDate:Date
        var bDate:Date
        let fileCount = fileNames.count
        print(fileCount)
        guard fileCount != 0 && fileCount != 1 else{
            return fileNames
        }
        for i in 0 ..< (fileCount-1){
            for j in (0 ..< (fileCount-1-i)){
                aDate = fileUpDate(fileName: fileNames[j], directName: nil, UDT:true) as! Date
                bDate = fileUpDate(fileName: fileNames[j+1], directName: nil, UDT:true) as! Date
                print(fileNames)
                
                if aDate < bDate{
                    fileNames.swapAt(j,j+1)
                }
            }
        }
        print(fileNames)
        return fileNames
    }
    
    func fileUpDate(fileName : String ,directName : String? ,UDT:Bool) -> Any{
        
        let directUrls:URL
        if directName != nil{
            directUrls = documentPaths[0].appendingPathComponent(directName!)
        }
        else{
            directUrls = documentPaths[0]
        }
        let urls = directUrls.appendingPathComponent(fileName)
        let attributes = try? fileManager.attributesOfItem(atPath: urls.path)
        if UDT == true{
            return attributes![.modificationDate]!
        }
        else{
            let jp_formatedTime = getDateTime.formateJPtime(UDT: attributes![.modificationDate]!)
            return jp_formatedTime
        }
    }
    
    
    func open_file(fileName: String ,directName: String?) -> String{
        let docsDirect = documentPaths[0]
        var url_s:URL
        if directName != nil{
            let fileDirect = docsDirect.appendingPathComponent(directName!)
            url_s = fileDirect.appendingPathComponent(fileName)
        }
        else{
            url_s = docsDirect.appendingPathComponent(fileName)
        }
        var fileContents = try? String(contentsOf: url_s, encoding: .utf8)
        
        if fileContents == nil{
            fileContents = "データはありませんでした"
        }
        return fileContents!
    }
    
    func create_Direct(directName: String) -> Bool{
       
        let fileManager = FileManager.default
        do{
            //ディレクトリ作成
            let docs = try fileManager.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil, create: false)
            let directPath = docs.appendingPathComponent(directName)
            print(directPath.path)
            try FileManager.default.createDirectory(atPath: directPath.path, withIntermediateDirectories : true, attributes: nil)
            
            return true
        }catch{
            print("createDirectNotFound")
            return false
        }
    }
    
    func savetext_File(directName : String? , FileName: String ,data: String) -> Bool{
        
        let saveDirectPath : URL
        if directName == nil{
            saveDirectPath = documentPaths[0]
        }
        else{
            saveDirectPath = documentPaths[0].appendingPathComponent(directName!)
        }
        
        let savePaths = saveDirectPath.appendingPathComponent(FileName+".txt")
        let Data = data.data(using: .utf8)!
        
        
        guard  fileManager.createFile(atPath: savePaths.path, contents: Data, attributes: nil) else{
            return false
        }
        return true
    }
    
    func newFileNameChecker(checkFileName: String?) -> Bool{
        
        let existingFileName = searchFile()
        if checkFileName == nil || checkFileName == ""{
            return false
        }
        else{
            for element in existingFileName!{
                if checkFileName == element{
                    return false
                }
            }
        }
        return true
    }
    
    func fileCounter() -> Int{
        
        let fileList = self.searchFile()
        guard fileList != nil else{
            return 0
        }
        return fileList!.count
    }
    
    func removeDirect(removeDirectName: String) -> Bool{
        
        let removeURL = documentPaths[0].appendingPathComponent(removeDirectName)
        do{
            try fileManager.removeItem(at: removeURL)
        }
        catch{
            return false
        }
        return true
    }
    
    func audioFileSave(directName:String)->Bool{
      
        let saveUrl = forAudioUrlPath()
        let toPath = documentPaths[0].appendingPathComponent(directName)
        let fullPath = toPath.appendingPathComponent("audio.m4a")
        do{
            try fileManager.moveItem(atPath: saveUrl.path, toPath: fullPath.path)
        }
        catch{
            print(error)
            return false
        }
        return true
    }
    
    func forAudioUrlPath() -> URL{
        let docsDirect = documentPaths[0]
        let url = docsDirect.appendingPathComponent("audio.m4a")
        return url
    }
    
    func saveImageFile(directName:String,image:UIImage)-> Bool{

        guard let jpegImage = image.jpegData(compressionQuality: 1.0) else{
            return false
        }
        
        let saveDirectPath = documentPaths[0].appendingPathComponent(directName)
        do{
            try jpegImage.write(to: saveDirectPath.appendingPathComponent("Image.jpg"))
        }
        catch{
            return false
        }
        return true
    }
    
    func loadImageFile(directName: String) -> UIImage?{
        let imageFilePath = documentPaths[0].appendingPathComponent(directName)
        if let imageData = try? Data(contentsOf: imageFilePath.appendingPathComponent("Image.jpg")),let image = UIImage(data: imageData){
            return image
        }
        return nil
    }
    
    struct languageCode: Codable{
        let name: String
        let code: String
    }
    
    func saveLanguageValue(languData: Dictionary<String,String>){
        let valueToSave = languageCode(name : languData["name"]!,code : languData["code"]!)
        
        if let encodedValue = try? encoder.encode(valueToSave){
            UserDefaults.standard.set(encodedValue, forKey: "languageData")
        }
    }
    
    func loadLanguageValue() -> Dictionary<String,String>{
        var languageDataDict:Dictionary<String,String>
        if let loadValue = UserDefaults.standard.data(forKey: "languageData"){
            if let decodeValue = try? decoder.decode(languageCode.self, from: loadValue){
                languageDataDict = ["name":decodeValue.name,"code":decodeValue.code]
                return languageDataDict
            }else{
                return ["name":"日本語","code":"ja-JP"]
            }
        }else{
            return ["name":"日本語","code":"ja-JP"]
        }
    }
}

