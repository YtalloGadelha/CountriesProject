//
//  CountryBusinessAPI.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation
import API

class CountryBusinessAPI: CountryBusinessProtocol {
    
    func getCountries(completion: @escaping (Result<[CountryModel], ErrorModel>) -> Void) {
        
        CountryAPIRepository().getCountries { result in
            
            switch result{
            
            case .success(let apiResponse):
                completion(.success(CountryModel.getCountries(from: apiResponse)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }    
}
