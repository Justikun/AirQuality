//
//  StateListTableViewController.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import UIKit

class StateListTableViewController: UITableViewController {

    // MARK: - Properties
    var country: String?
    var states: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fextchStates()
    }
    
    // MARK: - Helper Methods
    func fetchStates() {
        
        guard let country = country else {
            return
        }

        AirQualityControllers.fetchStates(for: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let states):
                    self.states = states
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        cell.textLabel?.text = states[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "toCitiesVC" {
            // Index, Destination
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityListTableViewController else { return }
            
            // Object to send
            let state = states[indexPath.row]
            destination.state = state
            destination.country = country
        }
    }
} // End of class
