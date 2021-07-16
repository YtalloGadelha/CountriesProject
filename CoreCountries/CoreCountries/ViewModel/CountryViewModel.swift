//
//  CountryViewModel.swift
//  CoreCountries
//
//  Created by Ytallo on 11/07/21.
//

import Foundation

protocol CountryViewModelDelegate: AnyObject {
    func didFinishWithSuccess()
    func didFinishWithError(message: String)
}

class CountryViewModel {
    
    weak var delegate: CountryViewModelDelegate?
    private let business: CountryBusinessProtocol
    private var countries: [CountryModel] = []
    
    var tableViewCount: Int{
        return self.countries.count
    }
    
    init(business: CountryBusinessProtocol = CountryBusinessAPI()) {
        self.business = business
    }    
    
    func fetchCountries(){
        self.business.getCountries { result in
            
            switch result{
            
            case .success(let countries):
                self.countries = countries
                self.delegate?.didFinishWithSuccess()
            case .failure(let error):
                self.countries = []
                self.delegate?.didFinishWithError(message: error.toString())
            }
        }
    }
    
    func getTableViewCellViewModel(from indexPath: IndexPath) -> CountryTableViewCellViewModel? {
        
        if(indexPath.row > countries.count){
            return nil
        }
        
        let model = countries[indexPath.row]
        
        return CountryTableViewCellViewModel(countryModel: model)
    }
}
