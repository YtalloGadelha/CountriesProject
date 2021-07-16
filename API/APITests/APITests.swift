//
//  APITests.swift
//  APITests
//
//  Created by Ytallo on 09/07/21.
//

import XCTest
@testable import API

class APITests: XCTestCase {
    
    var sut: CountryAPIProtocol!
    
    override func setUp() {
        super.setUp()
        self.sut = CountryAPIRepositoryMock()
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    func test_API_get_countries_success() {
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        var expectedResult: Result<CountryAPIResponse, CountryAPIError>?
        
        self.sut.getCountries { result in
            expectedResult = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let expectedResult = expectedResult else {
            
            XCTFail("Callback Error Timeout")
            
            return
        }
        
        switch expectedResult {
        
        case .success(_):
            XCTAssert(true)
        case .failure(_):
            XCTFail("Callback error")
        }
    }
    
    func test_API_get_countries_failure_invalid_url() {
        
        self.sut = CountryAPIRepositoryMock(error: .invalidURL)
        let expectedError: CountryAPIError = .invalidURL
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected Invalid URL")
            case .failure(let error):
                XCTAssertTrue(error == expectedError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_API_get_countries_failure_task_error() {
        
        self.sut = CountryAPIRepositoryMock(error: .taskError)
        let expectedError: CountryAPIError = .taskError
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected Task Error")
            case .failure(let error):
                XCTAssertTrue(error == expectedError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test_API_get_countries_failure_no_response() {
        
        self.sut = CountryAPIRepositoryMock(error: .noResponse)
        let expectedError: CountryAPIError = .noResponse
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected No Response")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_API_get_countries_failure_no_data() {
        
        self.sut = CountryAPIRepositoryMock(error: .noData)
        let expectedError: CountryAPIError = .noData
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected No data")
            case .failure(let error):
                XCTAssertTrue(error == expectedError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_API_get_countries_failure_invalid_json() {
        
        self.sut = CountryAPIRepositoryMock(error: .invalidJSON)
        let expectedError: CountryAPIError = .invalidJSON
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected Invalid Json")
            case .failure(let error):
                XCTAssertTrue(error == expectedError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_API_get_countries_failure_invalid_status_code() {
        
        self.sut = CountryAPIRepositoryMock(error: .invalidStatusCode)
        let expectedError: CountryAPIError = .invalidStatusCode
        
        let expectation = self.expectation(description: "API GET COUNTRIES")
        
        self.sut.getCountries { result in
            
            switch result{
            
            case .success(_):
                XCTFail("Expected Invalid Status Code")
            case .failure(let error):
                XCTAssertTrue(error == expectedError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
