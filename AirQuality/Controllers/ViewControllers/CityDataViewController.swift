//
//  CityDataViewController.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import UIKit

class CityDataViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var wsLabel: UILabel!
    @IBOutlet weak var tpLabel: UILabel!
    @IBOutlet weak var huLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    // MARK: - Properties
    var city: String?
    var state: String?
    var country: String?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityData()
    }
    
    // MARK: - Helper Methods
    func fetchCityData() {
        guard let city = city,
              let state = state,
              let country = country else { return }

        AirQualityControllers.fetchCityData(forCity: city, forState: state, forCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
            }
        }
    }
    
    func updateViews(with cityData: CityData) {
        
        let weatherData = cityData.data.current.weather
        let location = cityData.data.location.coordinates
        
        cityStateCountryLabel.text = "\(cityData.data.city), \(cityData.data.state), \(cityData.data.country)"
        aqiLabel.text = "AQI: \(cityData.data.current.pollution.aqius)"
        wsLabel.text = "Windspeed: \(weatherData.ws)"
        tpLabel.text = "Teperature: \(weatherData.tp)"
        huLabel.text = "Humidity: \(weatherData.hu)"
        latLongLabel.text = "Lat: \(location[0])\nLong: \(location[1])"
        
    }
    // MARK: - Navigation
}
