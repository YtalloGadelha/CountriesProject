//
//  CountryAPIProtocol.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation

public protocol CountryAPIProtocol {
    func getCountries(completion: @escaping (Result<CountryAPIResponse, CountryAPIError>) -> Void)
}
