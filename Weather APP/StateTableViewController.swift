//
//  StateTableViewController.swift
//  Weather APP
//
//  Created by victor mont-morency on 12/09/24.
//

import Foundation

import UIKit

class StateTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var stateKeys: [String] = []
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the state keys from JSON
        if let jsonData = loadJSON(from: "brazilianCities") {
            stateKeys = getStateKeys(from: jsonData)
        }

        // Create and configure the table view
        tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }

    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateKeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = stateKeys[indexPath.row]
        return cell
    }

    // TableView Delegate Method (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected state: \(stateKeys[indexPath.row])")
        dismiss(animated: true, completion: nil) // Dismiss the pop-up when a state is selected
    }

    // Load JSON function (same as previous)
    func loadJSON(from fileName: String) -> JSON? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                return json
            } catch {
                print("Error loading JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }

    // Get state keys function (same as previous)
    func getStateKeys(from json: JSON) -> [String] {
        return Array(json.keys)
    }
}
