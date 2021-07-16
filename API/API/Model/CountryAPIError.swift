//
//  CountryAPIError.swift
//  API
//
//  Created by Ytallo on 09/07/21.
//

import Foundation

public enum CountryAPIError: Error  {
    
    case invalidURL
    case taskError
    case noResponse
    case noData
    case invalidJSON
    case invalidStatusCode
    
    public func toString() -> String{
        switch self {
        
        case .invalidURL:
            return "URL inválida!"
        case .taskError:
            return "Erro na criação da tarefa!"
        case .noResponse:
            return "Sem resposta do servidor!"
        case .noData:
            return "Ausência de dados na resposta!"
        case .invalidJSON:
            return "O objeto JSON não pôde ser lido!"
        case .invalidStatusCode:
            return "Códido de status inválido!"
        }        
    }
}
