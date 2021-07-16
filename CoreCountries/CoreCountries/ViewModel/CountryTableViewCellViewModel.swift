//
//  CountryTableViewCellViewModel.swift
//  CoreCountries
//
//  Created by Ytallo on 12/07/21.
//

import Foundation
import UIKit

class CountryTableViewCellViewModel {
    
    private var model: CountryModel
    
    var flag: String {
        return self.model.flag
    }
    
    var name: String {
        return self.model.translations.brasil
    }
    
    var language: String {
        return self.model.languages.first?.name ?? ""
    }
    
    var isFavorite: Bool {
        return self.model.isFavorite
    }
    
    var image: URL?
    
    init(countryModel: CountryModel) {
        self.model = countryModel
        
    }
    
    func toggleFavorite(completion: @escaping(Bool) -> Void){
        
        DispatchQueue.main.async { [weak self] in
            guard let model = self?.model else { return completion(false) }
            
            let success = PersistentManager.favorite(countryModel: model, isFavorite: !model.isFavorite)
            
            if success{
                model.isFavorite = !model.isFavorite
            }
            completion(success)
        }
    }
    
    func downloaded(completion: @escaping(URL?) -> Void) {
        
        guard let image = self.image else {
            
            guard let url = URL(string: self.flag) else { return }
            
            self.image = url
            
            return completion(image)
        }
        
        completion(image)
    }
}
