//
//  APIClient.swift
//  Swift-PHP-MySQL-Practice
//
//  Created by 大西玲音 on 2021/12/10.
//

import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

final class APIClient {
    
    func fetchAllItems(text: String, completion: @escaping ResultHandler<[Item]>) {
        guard let url = URL(string: "http://localhost:8888/WebService/fetchAllItems.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func saveItem(text: String, completion: @escaping ResultHandler<Any?>) {
        guard let url = URL(string: "http://localhost:8888/WebService/saveItem.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(nil))
        }
        task.resume()
    }
    
}
