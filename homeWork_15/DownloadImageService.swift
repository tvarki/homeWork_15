//
//  DownloadImageService.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 13.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import Foundation

class DownloadImageService{
    
    func downloadImage(urlString :String,
                       completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else { return}
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let data = data,
                error == nil
                else { return }

            completion(data)
        }.resume()
    }
    
}
