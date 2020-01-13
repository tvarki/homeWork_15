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
    func setPost(post: Item){
        
        self.myLabel.text = post.title
        self.idLabel.text = String(post.id)
        self.myImage.image = post.image
        self.mySmallImageView.image = post.smallImage
    }
    
}
