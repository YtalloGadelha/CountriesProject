//
//  CountryAPIRepository.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation
import UIKit

//URL Countries
let basePath = "https://restcountries.eu/rest/v2?fields=name;languages;flag;capital;currencies;translations"

//https://restcountries.eu/rest/v2/name/colombia?fullText=true
//https://restcountries.eu/rest/v2/name/\(nameCountry)?fullText=true

public class CountryAPIRepository: CountryAPIProtocol {
    
    public init(){}
    
    static private let configuration: URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        return config
    }()
    
    static private let session = URLSession(configuration: configuration)    
    
    public func getCountries(completion: @escaping (Result<CountryAPIResponse, CountryAPIError>) -> Void ){
        
        guard let url = URL(string: "\(basePath)") else {
            
            completion(.failure(.invalidURL))
            return
        }
        
        let dataTask = CountryAPIRepository.session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?)  in
            
            if error == nil{
                
                guard let response = response as? HTTPURLResponse else {
                    
                    completion(.failure(.noResponse))
                    return
                }
                
                if response.statusCode == 200{
                    
                    guard let data = data else {
                        
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let dicts = json as? [[String:Any]]
                        let countries = dicts?.compactMap({ dict in
                            CountryAPIParser.getCountry(from: dict)
                        })
                        
                        let countryAPIResponse = CountryAPIResponse.init(countries: countries ?? [])
                        completion(.success(countryAPIResponse))
                        
                    }catch{
                        completion(.failure(.invalidJSON))
                    }
                }else{
                    completion(.failure(.invalidStatusCode))
                }
            }else{
                completion(.failure(.taskError))
            }
        }
        dataTask.resume()
    }
}
