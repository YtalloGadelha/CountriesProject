//
//  CountryViewModelTest.swift
//  CoreCountriesTests
//
//  Created by Ytallo on 16/07/21.
//

import XCTest
import API
@testable import CoreCountries

class CountryViewModelTest: XCTestCase {
    
    var sut: CountryBusinessProtocol!
    var viewModel: CountryViewModel!
    var delegate: CountryTestDelegate!

    func test_get_countries_with_success_empty(){
        
        let expectation = self.expectation(description: "CoreCountry GET COUNTRIES EMPTY")
        let expectedResult = 0
        
        self.sut = CountryBusinessMock(dummies: [])
        self.viewModel = CountryViewModel(business: self.sut)
        self.delegate = CountryTestDelegate.make(onSuccess: { [weak self, expectation, expectedResult] in
            
            guard let viewModel = self?.viewModel else {
                
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertTrue(viewModel.tableViewCount == expectedResult)
            expectation.fulfill()
            
        }, onError: { [expectation] errorMessage in
            
            XCTFail()
            expectation.fulfill()
        })
        self.viewModel.delegate = self.delegate
        self.viewModel.fetchCountries()
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_get_countries_with_success_(){
        
        let expectation = self.expectation(description: "CoreCountry GET COUNTRIES EMPTY")
        let expectedResult = 1
        
        self.sut = CountryBusinessMock(dummies: [CountryModel.init(name: "Brasil", flag: "", capital: "", translations: nil)])
        self.viewModel = CountryViewModel(business: self.sut)
        self.delegate = CountryTestDelegate.make(onSuccess: { [weak self, expectation, expectedResult] in
            
            guard let viewModel = self?.viewModel else {
                
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertTrue(viewModel.tableViewCount == expectedResult)
            expectation.fulfill()
            
        }, onError: { [expectation] errorMessage in
            
            XCTFail()
            expectation.fulfill()
        })
        self.viewModel.delegate = self.delegate
        self.viewModel.fetchCountries()
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_get_countries_name_with_success(){
        
        let expectation = self.expectation(description: "CoreCountry GET COUNTRIES")
        let expectedResult = "Brazil"
        
        self.sut = CountryBusinessMock(dummies: [
        
            CountryModel.init(name: "Brazil", flag: "", capital: "", translations: nil),
            CountryModel.init(name: "Portugal", flag: "", capital: "", translations: nil)
        ])
        self.viewModel = CountryViewModel(business: self.sut)
        self.delegate = CountryTestDelegate.make(onSuccess: { [weak self, expectation, expectedResult] in
            
            guard let cellViewModel = self?.viewModel.getTableViewCellViewModel(from: IndexPath.init(row: 0, section: 0)) else {
                
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertTrue(cellViewModel.name == expectedResult)
            expectation.fulfill()
            
        }, onError: { [expectation] errorMessage in
            
            XCTFail()
            expectation.fulfill()
        })
        self.viewModel.delegate = self.delegate
        self.viewModel.fetchCountries()
        waitForExpectations(timeout: 5, handler: nil)
        
    }
}

class CountryTestDelegate: CountryViewModelDelegate {
    
    private var onSuccess: (() -> Void)!
    private var onError: ((String) -> Void)!
    
    private init(){
        
    }
    
    static func make(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) -> CountryTestDelegate{
        
        let delegate = CountryTestDelegate()
        
        delegate.onSuccess = onSuccess
        delegate.onError = onError
        
        return delegate
    }
    
    func didFinishWithSuccess() {
        self.onSuccess()
        
    }
    
    func didFinishWithError(message: String) {
        self.onError("Erro no delegate da classe CountryViewModelDelegate")
    }
}
