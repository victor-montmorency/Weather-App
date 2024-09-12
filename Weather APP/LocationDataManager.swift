import Foundation

class LocationDataManager {
    static let shared = LocationDataManager()
    
    private let defaults = UserDefaults.standard
    
    private let keyLatitude = "persistedLatitude"
    private let keyLongitude = "persistedLongitude"
    private let keyCityName = "persistedCityName"
    private let keyFirstLaunch = "isFirstLaunch"
    
    private init() {}
    
    var latitude: String {
        get { defaults.string(forKey: keyLatitude) ?? "" }
        set { defaults.set(newValue, forKey: keyLatitude) }
    }
    
    var longitude: String {
        get { defaults.string(forKey: keyLongitude) ?? "" }
        set { defaults.set(newValue, forKey: keyLongitude) }
    }
    
    var cityName: String {
        get { defaults.string(forKey: keyCityName) ?? "" }
        set { defaults.set(newValue, forKey: keyCityName) }
    }
    
    var isFirstLaunch: Bool {
        get { defaults.bool(forKey: keyFirstLaunch) }
        set { defaults.set(newValue, forKey: keyFirstLaunch) }
    }
    
    func checkFirstLaunch() {
        if !isFirstLaunch {
            // This is the first launch
            print("This is the first time the app is launched")
            
            // Set default values if needed
            latitude = "-25.5313"
            longitude = "-49.2031"
            cityName = "São José dos Pinhais"
            
            // Set the flag to false so this block won't run again
            isFirstLaunch = true
        }
    }
}
