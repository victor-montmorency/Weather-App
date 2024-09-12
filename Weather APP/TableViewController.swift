//
//  TableViewController.swift
//  Weather APP
//
//  Created by victor mont-morency on 12/09/24.
//

import UIKit

class StringTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [String] = [] // Array to hold the strings (in this case, the states)
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 400)  // Set your desired height here
            
        ])
    }
    
    // MARK: - TableView DataSource and Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row]
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(data[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)

        presentCitiesModal(forState: "\(data[indexPath.row])", from: self)
        
    }
    
}
