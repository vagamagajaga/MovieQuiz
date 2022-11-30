//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation

struct NetworkClient {
    // MARK: - Enums
    private enum NetworkError: LocalizedError {
        case codeError
        case urlError
        var errorDescription: String? {
            switch self {
            case .codeError:
                return "CodeError"
            case .urlError:
                return "urlError"
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
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
