//
//  ViewController.swift
//  Swift-PHP-MySQL-Practice
//
//  Created by 大西玲音 on 2021/12/07.
//

import UIKit

struct Item: Decodable {
    
    let text: String
    
}

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

final class ViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAllItems(text: "")
        
    }
    
    @IBAction private func sendButtonDidTapped(_ sender: Any) {
        guard let text = textField.text else { return }
        APIClient().saveItem(text: text) { result in
            switch result {
            case .failure(let error):
                print("DEBUG_PRINT: ", error.localizedDescription)
            case .success:
                print("DEBUG_PRINT: ", "保存成功")
            }
        }
        textField.text = ""
    }
    
    @IBAction private func reflectButtonDidTapped(_ sender: Any) {
        guard let text = textField.text else { return }
        fetchAllItems(text: text)
    }
    
    private func fetchAllItems(text: String) {
        APIClient().fetchAllItems(text: text) { result in
            switch result {
            case .failure(let error):
                print("DEBUG_PRINT: ", error.localizedDescription)
            case .success(let items):
                self.items = items.map { $0.text }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
