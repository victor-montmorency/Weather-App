import Foundation

// Define a type alias for your JSON structure
typealias JSON = [String: Any]

// Function to load JSON from file
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

// Function to get state keys from JSON
func getStateKeys(from json: JSON) -> [String] {
    return Array(json.keys)
}

// Function to load and print state keys
func loadAndPrintStateKeys(from fileName: String) -> Array<String> {
    guard let jsonData = loadJSON(from: fileName) else { return [] }
        let stateKeys = getStateKeys(from: jsonData)
    return stateKeys.sorted()
}

// Example usage
// loadAndPrintStateKeys(from: "brazilianCities")

import UIKit

class CitiesTableViewController: UITableViewController {
    
    var citiesDict: [String: [String: [String: Double]]]?

    
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Cities"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        
        // Perform action with the selected city
        // Deselect the row after selection (optional)
        var coordenadas = persistir["\(selectedCity)"]
        var latitude: Double = coordenadas?["latitude"] ?? 0.0
        var longitude: Double = coordenadas?["longitude"] ?? 0.0
        
        LocationDataManager.shared.latitude = "\(latitude)"
        LocationDataManager.shared.longitude = "\(longitude)"
        LocationDataManager.shared.cityName = "\(selectedCity)"
        
        print(LocationDataManager.shared.cityName)
        dismissAllModals()

        
    }
    
    
}
var persistir: [String : [String : Double]] = [:]

func presentCitiesModal(forState state: String, from viewController: UIViewController) {
    // Get the file path for the JSON file
    if let filePath = Bundle.main.path(forResource: "brazilianCities", ofType: "json") {
        do {
            // Load the file contents
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            
            // Parse the JSON data
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: [String: [String: Double]]]
            
            // Extract city names based on the state key
            if let citiesDict = jsonObject?[state] {
                persistir = citiesDict
                print(" ")
                let cities = Array(citiesDict.keys).sorted()
                
                // Create and configure the modal view controller
                let citiesVC = CitiesTableViewController(style: .plain)
                citiesVC.cities = cities
                
                // Present the modal view controller
                let navigationController = UINavigationController(rootViewController: citiesVC)
                navigationController.modalPresentationStyle = .formSheet
                viewController.present(navigationController, animated: true, completion: nil)
            } else {
                print("State not found in JSON")
            }
        } catch {
            print("Error loading or parsing JSON: \(error)")
        }
    } else {
        print("File brazilianCities.json not found")
    }

}
extension UIViewController {
    func dismissAllModals() {
        if let presentingVC = self.presentingViewController {
            self.dismiss(animated: true) {
                presentingVC.dismissAllModals()
            }
        } else {
            print("No more modals to dismiss.")
        }
    }
}
