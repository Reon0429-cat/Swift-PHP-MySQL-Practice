//
//  ViewController.swift
//  Swift-PHP-MySQL-Practice
//
//  Created by 大西玲音 on 2021/12/07.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction private func sendButtonDidTapped(_ sender: Any) {
        guard let url = URL(string: "http://localhost:8888/WebService/saveUser.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let text = textField.text else { return }
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_PRINT: ", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                print("DEBUG_PRINT: ", user.text)
            } catch {
                print("DEBUG_PRINT: ", error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

struct User: Decodable {
    
    let text: String
    
}
