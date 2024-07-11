//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation

struct NetworkClient: NetworkRouting {
    //MARK: - Variables
    private let session: URLSession
    
    //MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Enums
    private enum NetworkError: LocalizedError {
        case serverError(Int)
        case noData
        
        var errorDescription: String? {
            switch self {
            case .serverError(let codeError):
                return "ServerError: \(codeError)"
            case .noData:
                return "No Data"
            }
        }
    }
    
    // MARK: - Methods
    func fetch<DataType>(url: URL) async throws -> DataType {
        let (data, response) = try await session.data(from: url)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode < 200 ||  response.statusCode >= 300 {
            print(NetworkError.serverError(response.statusCode))
        }
        
        guard let result = data as? DataType else {
            throw NetworkError.noData
        }
        
        return result
    }
}
