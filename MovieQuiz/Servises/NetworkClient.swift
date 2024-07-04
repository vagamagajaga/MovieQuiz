//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation

struct NetworkClient: NetworkRouting {
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
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.serverError(response.statusCode)))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
    
    func fetch(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse,
           response.statusCode < 200 ||  response.statusCode >= 300 {
            print(NetworkError.serverError(response.statusCode))
        }
        
        return data
    }
}
