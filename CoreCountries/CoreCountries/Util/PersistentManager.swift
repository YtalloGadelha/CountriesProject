//
//  PersistentManager.swift
//  CoreCountries
//
//  Created by Ytallo on 13/07/21.
//

import Foundation
import CoreData

struct PersistentManager {
    
    static func getCountry(by name: String) -> Country?{
        
        guard let context = AppDelegate.context else { return nil }
        
        if name != ""{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
            request.predicate = NSPredicate(format: "name == %@", name)
            request.returnsObjectsAsFaults = false
            
            do{
                let result = try context.fetch(request)
                return result.first as? Country ?? Country(context: context)
                
            }catch{
                print("Failed")
                return Country(context: context)
            }
        }
        return Country(context: context)
    }
    
    static func getCurrency(by code: String) -> Currency?{
        
        guard let context = AppDelegate.context else { return nil }
        
        if code != ""{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
            request.predicate = NSPredicate(format: "code == %@", code)
            request.returnsObjectsAsFaults = false
            
            do{
                let result = try context.fetch(request)
                return result.first as? Currency ?? Currency(context: context)
                
            }catch{
                print("Failed")
                return Currency(context: context)
            }
        }
        return Currency(context: context)
    }
    
    static func getLanguage(by nativeName: String) -> Language?{
        
        guard let context = AppDelegate.context else { return nil }
        
        if nativeName != ""{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Language")
            request.predicate = NSPredicate(format: "nativeName == %@", nativeName)
            request.returnsObjectsAsFaults = false
            
            do{
                let result = try context.fetch(request)
                return result.first as? Language ?? Language(context: context)
                
            }catch{
                print("Failed")
                return Language(context: context)
            }
        }
        return Language(context: context)
    }
    
    static func getTranslation() -> Translation?{
        
        guard let context = AppDelegate.context else { return nil }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Translation")
        
        do{
            let result = try context.fetch(request)
            return result.first as? Translation ?? Translation(context: context)
            
        }catch{
            print("Failed")
            return Translation(context: context)
        }
    }
    
    static func saveCountries(countryModel: [CountryModel]){
        
        guard let context = AppDelegate.context else { return }
        
        DispatchQueue.main.async{ [context] in
            
            for country in countryModel{
                
                let countryEntity = getCountry(by: country.name)
                countryEntity?.name = country.name
                countryEntity?.capital = country.capital
                countryEntity?.flag = country.flag
                country.isFavorite = countryEntity?.isFavorite ?? false
                try? context.save()
                
                for currency in country.currencies{
                    
                    let currencyEntity = getCurrency(by: currency.code)
                    currencyEntity?.code = currency.code
                    currencyEntity?.name = currency.name
                    try? context.save()
                    
                }
                
               for language in country.languages{
                    
                let languageEntity = getLanguage(by: language.nativeName)
                languageEntity?.name = language.name
                languageEntity?.nativeName = language.nativeName
                try? context.save()
                    
                }
                
                let translationEntity = getTranslation()
                translationEntity?.brasil = country.translations.brasil
                try? context.save()
                
            }
        }
    }
    
    static func favorite(countryModel: CountryModel, isFavorite: Bool) -> Bool{
        
        guard let context = AppDelegate.context else { return false}
        
        let country = getCountry(by: countryModel.name)
        country?.isFavorite = isFavorite
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
