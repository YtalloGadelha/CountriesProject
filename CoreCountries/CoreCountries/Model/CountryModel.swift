//
//  CountryModel.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation
import API

class CountryModel {
    
    let name: String
    let flag: String
    let capital: String
    let currencies: [Currencies]
    let languages: [Languages]
    let translations: Translations
    var isFavorite: Bool = false
    
    init(name: String, flag: String, capital:String, currencies: [Currencies], languages: [Languages], translations: Translations, isFavorite: Bool = false) {
        self.name = name
        self.flag = flag
        self.capital = capital
        self.currencies = currencies
        self.languages = languages
        self.translations = translations
        self.isFavorite = isFavorite
    }
    
    static func getCountries(from api: CountryAPIResponse) -> [CountryModel] {
        
        let data = api.countries.compactMap { apiCountry in
            CountryModel.init(name: apiCountry.name, flag: apiCountry.flag, capital: apiCountry.capital, currencies: apiCountry.currencies, languages: apiCountry.languages, translations: apiCountry.translations)
        }
        
        PersistentManager.saveCountries(countryModel: data)
        
        return data
    }
}


