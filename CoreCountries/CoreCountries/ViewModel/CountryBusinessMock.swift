//
//  CountryBusinessMock.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation

public class CountryBusinessMock: CountryBusinessProtocol {
    
    let dummies: [CountryModel]
    
    public init(dummies: [CountryModel]) {
        self.dummies = dummies
    }
    
    public func getCountries(completion: @escaping (Result<[CountryModel], ErrorModel>) -> Void) {
        completion(.success(self.dummies))
    }
}
