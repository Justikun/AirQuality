//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Justin Lowry on 1/6/22.
//

import Foundation

class AirQualityControllers {
    // MARK: - String Constants
    static let baseURL = URL(string: "https://api.airvisual.com")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "5949efb7-59c8-4e29-8b1d-5c4350e7f2bc"
    
    // http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    // fetch countires
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        // URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        // Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Data task Error", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            // Data check
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            // Data decode
            do {
                let allCountriesDataObject = try JSONDecoder().decode(Countries.self, from: data)
                let allCountriesDataArray = allCountriesDataObject.data
                
                var countries: [String] = []
                
                for country in allCountriesDataArray {
                    countries.append(country.countryName)
                }
                
                return completion(.success(countries))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }

        }.resume()
    }
    
    
    //http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    // fetch states
    
    static func fetchStates(for country: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        // URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: country)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        // Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // Error handling
            if let error = error {
                print("Data task error", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            // Data check
            guard let data = data else { return completion(.failure(.noData)) }
            
            // Data decode
            do {
                let allStatesDataObject = try JSONDecoder().decode(State.self, from: data)
                let allStatesDataArray = allStatesDataObject.data
                
                var stateNames: [String] = []
                
                for state in allStatesDataArray {
                    stateNames.append(state.stateName)
                }
                
                return completion(.success(stateNames))
            } catch {
                print("Unable to decode", error, error.localizedDescription)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    // fetch cities
    static func fetchCities(forState state: String, inCountry country: String, completion: @escaping (Result<[String],NetworkError>) -> Void) {
        // URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: state)
        let countryQuery = URLQueryItem(name: countryKey, value: country)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
    
        // Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // Error handling
            if let error = error {
                print("Data task Error", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            // Data check
            guard let data = data else { print("No Data")
                return completion(.failure(.noData)) }
            
            // Data decode
            do {
                let citiesDataObject = try JSONDecoder().decode(City.self, from: data)
                let citiesDataArray = citiesDataObject.data
                
                var cityStrings: [String] = []
                for city in citiesDataArray {
                    cityStrings.append(city.cityName)
                }
                
                return completion(.success(cityStrings))
            } catch {
                print("Unable to decode", error, error.localizedDescription)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    // http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    // fetch city data
    static func fetchCityData(forCity city: String, forState state: String, forCountry country: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        // URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: city)
        let stateQuery = URLQueryItem(name: stateKey, value: state)
        let countryQuery = URLQueryItem(name: countryKey, value: country)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        // Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // Error handling
            if let error = error {
                print("Data task Error", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            // Data check
            guard let data = data else { return completion(.failure(.noData)) }
            
            // Data decode
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            } catch {
                print("Unable to decode", error, error.localizedDescription)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
} // End of class
