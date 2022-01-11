//
//  CityListTableViewController.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import UIKit

class CityListTableViewController: UITableViewController {

    // MARK: - Properties
    var state: String?
    var country: String?
    
    var cities: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCities()
    }
    
    // MARK: - Helper Methods
    func fetchCities() {
        guard let state = state,
              let country = country else { return }
        AirQualityControllers.fetchCities(forState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                    self.tableView.reloadData()
                    print("HERE")
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
            }
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        cell.textLabel?.text = cities[indexPath.row]

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toCityDataVC" {
            // Index path
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityDataViewController else { return }
            
            // Object to send
            destination.city = cities[indexPath.row]
            destination.state = state
            destination.country = country
        }
        
    }
} // End of class
