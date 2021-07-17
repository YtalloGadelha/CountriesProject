//
//  CountryModel.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation
import API

public class CountryModel {
    
    public let name: String
    public let flag: String
    public let capital: String
    public let currencies: [Currencies]
    public let languages: [Languages]
    public let translations: Translations
    public var isFavorite: Bool = false
    
    public init(name: String, flag: String, capital:String, currencies: [Currencies], languages: [Languages], translations: Translations, isFavorite: Bool = false) {
        self.name = name
        self.flag = flag
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
        self.translations = translations
        self.isFavorite = isFavorite
    }
    
    public init(name: String, flag: String, capital:String, translations: Translations?, isFavorite: Bool = false) {
        
        self.name = name
        self.flag = flag
        self.capital = capital
        self.currencies = []
        self.languages = []
        self.translations = translations ?? Translations(brasil: "")
        self.isFavorite = isFavorite
    }
    
    public static func getCountries(from api: CountryAPIResponse) -> [CountryModel] {
        
        let data = api.countries.compactMap { apiCountry in
            CountryModel.init(name: apiCountry.name, flag: apiCountry.flag, capital: apiCountry.capital, currencies: apiCountry.currencies, languages: apiCountry.languages, translations: apiCountry.translations)
        }
        
        PersistentManager.saveCountries(countryModel: data)
        
        return data
    }
}


