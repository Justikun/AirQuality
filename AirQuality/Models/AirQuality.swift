//
//  AirQuality.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import Foundation

struct Countries: Decodable {
    let data: [Country]
    
    struct Country: Decodable {
        let countryName: String
        
        enum CodingKeys: String, CodingKey {
            case countryName = "country"
        }
    } // End of struct
} // End of struct

struct State: Decodable {
    let data: [State]
    
    struct State: Decodable {
        let stateName: String
        
        enum CodingKeys: String, CodingKey {
            case stateName = "state"
        }
    } // End of struct
} // End of struct


struct City: Decodable {
    let data: [City]
    
    struct City: Decodable {
        let cityName: String
        
        enum CodingKeys: String, CodingKey {
            case cityName = "city"
        }
    } // End of struct
} // End of struct


struct CityData: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let city: String
        let state: String
        let country: String
        let location: Location
        let current: Current
        
        struct Location: Decodable {
            let coordinates: [Double]
        } // End of struct
        
        struct Current: Decodable {
            let weather: Weather
            let pollution: Pollution
            
            struct Weather: Decodable {
                let tp: Int
                let hu: Int
                let ws: Double
                
            } // End of struct
            
            struct Pollution: Decodable {
                let aqius: Int
                
            } // End of struct
            
        } // End of struct
    } // End of struct
} // End of struct
