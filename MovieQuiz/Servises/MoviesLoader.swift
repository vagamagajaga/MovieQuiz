//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation



struct MoviesLoader: MoviesLoadingProtocol {
    // MARK: - Error
    private enum MoviesLoaderError: LocalizedError {
        case decodeError
        case messageError
        var errorDescription: String? {
            switch self {
            case .decodeError:
                return "Decode Error"
            case .messageError:
                return "Message Error"
            }
        }
    }
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var moviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_r0f51fxi") else {
            preconditionFailure("Unable to construct moviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: moviesUrl) { result in
            switch result {
            case .failure(let error): handler(.failure(error))
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(MoviesLoaderError.decodeError))
                }
            }
        }
    }
}


