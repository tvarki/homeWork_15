//
//  PostTableViewCell.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 26.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var mySmallImageView: UIImageView!
    
    
    let fileModel = FileModel(directoryName: "imgs")
    let networkManager = NetworkManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // MARK: - setPost - if file exist show file content else download image
    func setPost(post: Post){
        
        self.myLabel.text = post.title
        self.idLabel.text = String(post.id)
        
        var data = fileModel.readData(link: post.url)
        
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        let largeBolt = UIImage(systemName: "bolt", withConfiguration: largeConfig)
        
        if data == nil {
            self.myImage.image = largeBolt
            networkManager.downloadImage(urlString: post.url,
                                         completion: { tmp in
                                            data = tmp
                                            self.fileModel.saveData(link: post.url, data: data)
                                            guard let data = data else {return}
                                            DispatchQueue.main.async {
                                                self.myImage.image = UIImage(data: data)
                                            }
            } )
        }else{
            self.myImage.image = UIImage(data: data!)
        }
        
        var smallData = fileModel.readData(link: post.thumbnailUrl)
        if smallData == nil {
            
            self.mySmallImageView.image = largeBolt
            
            networkManager.downloadImage(urlString: post.url,
                                         completion: { tmp in
                                            smallData = tmp
                                            self.fileModel.saveData(link: post.thumbnailUrl, data: smallData)
                                            guard let smallData = smallData else {return}
                                            DispatchQueue.main.async {
                                                self.mySmallImageView.image = UIImage(data: smallData)
                                            }
            } )
        }else{
            self.mySmallImageView.image = UIImage(data: smallData!)
            
        }
    }
    
}
