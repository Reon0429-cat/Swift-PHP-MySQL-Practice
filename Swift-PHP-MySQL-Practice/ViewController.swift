//
//  ViewController.swift
//  Swift-PHP-MySQL-Practice
//
//  Created by 大西玲音 on 2021/12/07.
//

import UIKit

struct Result: Decodable {
    
    let message: String
    
}

struct Item: Decodable {
    
    let text: String
    
}

final class ViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let url = URL(string: "http://localhost:8888/WebService/fetchAllItems.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let text = textField.text else { return }
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                self.items = items.map { $0.text }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    @IBAction private func sendButtonDidTapped(_ sender: Any) {
        guard let url = URL(string: "http://localhost:8888/WebService/saveItem.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let text = textField.text else { return }
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                print("DEBUG_PRINT\(#line) :", result.message)
            } catch {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
            }
        }
        task.resume()
        textField.text = ""
    }
    
    @IBAction private func reflectButtonDidTapped(_ sender: Any) {
        guard let url = URL(string: "http://localhost:8888/WebService/fetchAllItems.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let text = textField.text else { return }
        let postParameters = "text=\(text)"
        request.httpBody = postParameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                self.items = items.map { $0.text }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("DEBUG_PRINT\(#line) :", error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
}
