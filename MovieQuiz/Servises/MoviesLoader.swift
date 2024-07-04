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
        case loadError(message: String)
        var errorDescription: String? {
            switch self {
            case .decodeError:
                return "Decode Error"
            case .loadError(let message):
                return "Load Error: \(message)"
            }
        }
    }
    
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()){
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var moviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct moviesUrl")
        }
        return url
    }
    
    private var trailerURL: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Trailer/k_zcuw1ytf/") else {
            preconditionFailure("Невозможно достать значение по ссылке!")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: moviesUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                guard let decodedMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: data) else {
                    handler(.failure(MoviesLoaderError.decodeError))
                    return
                }
                if decodedMovies.errorMessage.isEmpty {
                    handler(.success(decodedMovies))
                } else {
                    handler(.failure(MoviesLoaderError.loadError(message: decodedMovies.errorMessage)))
                }
            }
        }
    }
    
    func loadMoviesTrailer(id: String, handler: @escaping (Result<MoviesDetailModel, Error>) -> ()) {
        guard let fullUrl = URL(string: trailerURL.absoluteString + id) else { return }
        networkClient.fetch(url: fullUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                guard let decodedMovie = try?
                        JSONDecoder().decode(MoviesDetailModel.self, from: data) else {
                    handler(.failure(LoaderErrors.jsonError))
                    return
                }
                
                if decodedMovie.errorMessage.isEmpty {
                    handler(.success(decodedMovie))
                } else {
                    handler(.failure(LoaderErrors.errorMessageFromData))
                }
            }
        }
    }
    
    private enum LoaderErrors: Error {
        case jsonError
        case errorMessageFromData
    }
}
