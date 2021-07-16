//
//  CountryBusinessProtocol.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation

protocol CountryBusinessProtocol {
    func getCountries(completion: @escaping(Result<[CountryModel], ErrorModel>) -> Void)
}
