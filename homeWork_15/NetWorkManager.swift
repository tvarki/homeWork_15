//
//  NetWorkManager.swift
//  homeWork_15
//
//  Created by Дмитрий Яковлев on 26.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit


enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
    case HEAD
    // другие
}

enum Result<T> {
    case some(object: T)
    case error(description: String)
}

class NetworkManager{
    
    let baseURL = "https://jsonplaceholder.typicode.com"
    
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
//
    
    func sendRequest<U: Decodable>(
        endPoint: String,
        httpMethod: HTTPMethod = .GET,
        headers: [String: String],
        parseType: U.Type,
        completion: @escaping (Result<U>) -> Void
    ) {
        let urlString = baseURL + endPoint
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(Result.error(description: error.localizedDescription))
            }
            if
                let data = data {
                do {
                    let result = try JSONDecoder().decode(parseType, from: data)
                    // возврат
                    
                    completion(Result.some(object: result))
                } catch {
                    print(error)
                    completion(Result.error(description: error.localizedDescription))
                }
            } else {
                completion(Result.error(description: "C сервера не пришли данные"))
            }
        }
        task.resume()
    }
    
}
