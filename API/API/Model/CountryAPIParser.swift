//
//  CountryAPIParser.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation

public struct CountryAPIParser {
    
    static func getCountry(from dict: [String: Any]) -> Country{
        
        let currenciesDicts = dict["currencies"] as? [[String: Any]] ?? [[:]]
        let currencies = currenciesDicts.compactMap({ dict in
            CountryAPIParser.getCurrencies(from: dict)
        })
        
        let languagesDicts = dict["languages"] as? [[String: Any]] ?? [[:]]
        let languages = languagesDicts.compactMap({ dict in
            CountryAPIParser.getLanguages(from: dict)
        })
        
        let translationsDict = dict["translations"] as? [String: Any] ?? [:]
        let translations = CountryAPIParser.getTranslations(from: translationsDict)
        
        let flag = dict["flag"] as? String
        let name = dict["name"] as? String
        let capital = dict["capital"] as? String
        
        let country = Country(currencies: currencies, languages: languages, translations: translations, flag: flag ?? "", name: name ?? "", capital: capital ?? "")
        
        return country
    }
    
    static func getCurrencies(from dict: [String: Any]) -> Currencies{
        
        let code = dict["code"] as? String
        let name = dict["name"] as? String
        let currencies = Currencies(code: code ?? "", name: name ?? "")
        
        return currencies
    }
    
    static func getLanguages(from dict: [String: Any]) -> Languages{
        
        let name = dict["name"] as? String
        let nativeName = dict["nativeName"] as? String
        let languages = Languages(name: name ?? "", nativeName: nativeName ?? "")
        
        return languages
    }
    
    static func getTranslations(from dict: [String: Any]) -> Translations{
        
        let br = dict["br"] as? String
        let translations = Translations(brasil: br ?? "")
        
        return translations
    }
    
    static func getAPIResponseMock() -> CountryAPIResponse{
        
        let currencies = [Currencies(code: "11", name: "peso"),Currencies(code: "11", name: "peso")]
        let languages = [Languages(name: "es", nativeName: "es"),Languages(name: "es", nativeName: "es")]
        let translations = Translations(brasil: "pt")
        let flag = "dhjkfggsd"
        let name = "brasil"
        let capital = "brasília"
        
        let country = Country(currencies: currencies, languages: languages, translations: translations, flag: flag, name: name, capital: capital)
        
        let countries = [country,country,country]
        
        return CountryAPIResponse(countries: countries)
    }
}
