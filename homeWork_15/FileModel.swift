//
//  FileModel.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 29.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import Foundation


class FileModel{
    
    let fileManager = FileManager()
    let tempDir = NSTemporaryDirectory()
    let directoryName : String
    var dataPath: URL? = nil
    
    init(directoryName: String){
        self.directoryName = directoryName
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        guard let docURL = URL(string: documentsDirectory) else {return}
        self.dataPath = docURL.appendingPathComponent(directoryName)
    }
    
    
    // MARK: - create directory if  not exist
    func prepeareDirectory()->Bool{
        guard let dataPath = dataPath else {return false}
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
                return false
            }
        }
        return true
    }
    
    // MARK: - save data on link
    func saveData(link: String ,data: Data?){
        guard let dataPath = dataPath else {return}

        DispatchQueue.global().async {
        
            let fileName = self.getFileName(link: link)
            let url =  dataPath.appendingPathComponent(fileName)
            if !FileManager.default.fileExists(atPath: url.absoluteString) {
                self.createFile(path: url.absoluteString)
            }
            do {
                guard  let data = data  else { return }
                let url = URL(fileURLWithPath: url.absoluteString)
                try data.write(to: url, options: .atomic )
                
            } catch let error as NSError {
                print("could't create file on path : \(url.absoluteString) because of error: \(error)")
                return
            }
        }
    }
    
    func createFile(path: String){
        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    // MARK: - read data
    func readData(link: String)->Data?{
        guard let dataPath = dataPath else {return nil}
        let fileName = self.getFileName(link: link)
        let url =  dataPath.appendingPathComponent(fileName)
        let tst = URL(fileURLWithPath: url.absoluteString)
        print(tst.relativeString)
        let contentsOfFile = try? Data(contentsOf: tst)
        return contentsOfFile
    }
    
    func deleteFile(url: URL) -> Bool{
        do {
            try fileManager.removeItem(at: url)
            print("file deleted")
        } catch let error as NSError {
            print("error occured while deleting file: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    
        func getFileName(link: String)->String{    
            return String(link.myHash)

        }
    
    
}


import Foundation

extension FileManager {
    func urls(for directory: URL, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let fileURLs = try? contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

// Usage
