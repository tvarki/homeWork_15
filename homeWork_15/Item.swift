//
//  Item.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 13.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import UIKit


protocol UpdataItem: AnyObject{
    func updatItem(at: Int)
}

class Item{
    let albumId: Int
    let id: Int
    let title: String
    var image: UIImage?
    var smallImage: UIImage?
    
    weak var delegate : UpdataItem?

    
    let fileModel = FileModel(directoryName: "imgs")
    let networkManager = NetworkManager()
    let service = DownloadImageService()
    
    init(post: Post){
        albumId = post.albumId
        id = post.id
        title = post.title
        
        var data = fileModel.readData(link: post.url)
        
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        guard let largeBolt = UIImage(systemName: "bolt", withConfiguration: largeConfig)
            else{return}
        
        if data == nil {
            self.image = largeBolt
            service.downloadImage(urlString: post.url,
                                         completion: { tmp in
                                            data = tmp
                                            self.fileModel.saveData(link: post.url, data: data)
                                            guard let data = data else {return}
                                            DispatchQueue.main.async {
                                                self.image = UIImage(data: data) ?? largeBolt
                                                self.delegate?.updatItem(at: post.id - 1)
                                            }
            } )
        }else{
            self.image = UIImage(data: data!)
        }
        
        var smallData = fileModel.readData(link: post.thumbnailUrl)
        if smallData == nil {
            
            self.smallImage = largeBolt
            service.downloadImage(urlString: post.url,
                                         completion: { tmp in
                                            smallData = tmp
                                            self.fileModel.saveData(link: post.thumbnailUrl, data: smallData)
                                            guard let smallData = smallData else {return}
                                            DispatchQueue.main.async {
                                                self.smallImage = UIImage(data: smallData) ?? largeBolt
                                                self.delegate?.updatItem(at: post.id - 1)

                                            }
            } )
        }else{
            self.smallImage = UIImage(data: smallData!)
        }

    }
    
    
    
    
    
}
