//
//  PostModel.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 26.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import Foundation

protocol ModelUpdating: AnyObject{
    func updateModel()
    func showError(error:String)
}

class PostModel{
    
    weak var delegate : ModelUpdating?
    let netManager = NetworkManager()
    let directoryName : String
    let fileModel : FileModel
    
    private var postArray : [Post] = []
    
    private var isDataCashPosssible = true
    
    
    var addedCount = 0
    var fromIndex = 0
    var batchSize = 50
    
    // MARK: - init
    init(dName : String){
        directoryName = dName
        fileModel = FileModel(directoryName: directoryName)
        self.updateModel()
        isDataCashPosssible = fileModel.prepeareDirectory()
    }
    
    func initModel(t : Bool = true){
        if t{
            postArray = []
            fromIndex = 0
        }
        self.updateModel()
    }
    
    func getModel()->[Post]{
        return postArray
    }
    
    func getModelCount()-> Int{
        return postArray.count
    }
    
    func getPost(at: Int)-> Post? {
        guard at <= postArray.count else{return nil}
        return postArray[at]
    }
    
    
    // MARK: - update - ask json
    func updateModel(){
        
        self.fromIndex = self.postArray.count
        sendGetReqest(
            completion: { tmp in
                self.postArray += tmp
                self.delegate?.updateModel()
        },
            failure: { error in
                DispatchQueue.main.async {
                    self.delegate?.showError(error: error)
                }
        })
    }

    
    // MARK: - sendGetReqest
    private func sendGetReqest( completion: (([Post]) -> Void)?, failure: ((String) -> Void)?) {
        
        netManager.sendRequest(
            endPoint: "/photos?_start=\(String(fromIndex))&_limit=\(String(batchSize))",
            httpMethod: .GET,
            headers: ["Content-Type": "application/json"],
            parseType: [Post].self
        ) { result in
            switch result {
            case .error(let error):
                print(error)
                failure?(error)
            case .some(let object):
                //                dump(object)
                completion?(object)
            }
        }
    }
}


// MARK: - myHash for file name from link
extension String {
    var myHash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}
