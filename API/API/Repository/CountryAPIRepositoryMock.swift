//
//  CountryAPIRepositoryMock.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation

public class CountryAPIRepositoryMock: CountryAPIProtocol {
    
    var error: CountryAPIError?
    
    public init() {
        
    }
    
    public convenience init(error: CountryAPIError) {
        self.init()
        self.error = error
    }
    
    public func getCountries(completion: @escaping (Result<CountryAPIResponse, CountryAPIError>) -> Void){
        
        guard let error = self.error else { return completion(.success(CountryAPIParser.getAPIResponseMock())) }
        
        completion(.failure(error))
        
    }
}
