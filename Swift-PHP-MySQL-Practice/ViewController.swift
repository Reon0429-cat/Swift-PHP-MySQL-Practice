//
//  ViewController.swift
//  Swift-PHP-MySQL-Practice
//
//  Created by 大西玲音 on 2021/12/07.
//

import UIKit

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
