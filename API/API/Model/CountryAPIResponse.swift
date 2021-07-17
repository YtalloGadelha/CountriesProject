//
//  CountryAPIResponse.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation
import UIKit

public struct CountryAPIResponse {
    public let countries: [Country]
    
    public init(countries: [Country]) {
        self.countries = countries
    }
}

public struct Country {
    
    public let currencies: [Currencies]
    public let languages: [Languages]
    public let translations: Translations
    public let flag: String
    public let name: String
    public let capital: String
}

public struct Currencies {
    public let code: String
    public let name: String
}

public struct Languages {
    public let name: String
    public let nativeName: String
}


public struct Translations {
    public let brasil: String
    
    public init(brasil: String){        
        self.brasil = brasil
    }
}
