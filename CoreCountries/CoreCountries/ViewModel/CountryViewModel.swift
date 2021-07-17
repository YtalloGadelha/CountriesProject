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
    private var countries: [CountryModel] = [] {
        didSet{
            self.countriesFiltered = self.countries
        }
    }
    private var countriesFiltered: [CountryModel] = []
    
    var tableViewCount: Int{
        return self.countriesFiltered.count
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
        
        if(indexPath.row > countriesFiltered.count){
            return nil
        }
        
        let model = countriesFiltered[indexPath.row]
        
        return CountryTableViewCellViewModel(countryModel: model)
    }
    
    func filterByName(from name: String){
        
        if(name.isEmpty){
            self.countriesFiltered = self.countries
            
        }
        else{            
            self.countriesFiltered = self.countries.filter({ model in
                model.name.lowercased().contains(name.lowercased())
            })
        }        
        self.delegate?.didFinishWithSuccess()
    }
}
