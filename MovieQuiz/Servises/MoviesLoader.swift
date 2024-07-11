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
        case urlError
        case networkError
        var errorDescription: String? {
            switch self {
            case .decodeError:
                return "Decode Error"
            case .loadError(let message):
                return "Load Error: \(message)"
            case .urlError:
                return "UrlError"
            case .networkError:
                return "Network Error"
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
    
    func loadMovies() async throws -> MostPopularMovies {
        do {
            let fetchData = try await networkClient.fetch(url: moviesUrl)
            
            guard let decodedMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: fetchData) else {
                throw MoviesLoaderError.decodeError
            }
            
            if decodedMovies.errorMessage.isEmpty {
                return decodedMovies
            } else {
                throw MoviesLoaderError.loadError(message: decodedMovies.errorMessage)
            }
        } catch {
            throw MoviesLoaderError.networkError
        }
    }
    
    func loadMoviesTrailerLink(id: String) async throws -> String {
        guard let fullUrl = URL(string: trailerURL.absoluteString + id) else {
            throw MoviesLoaderError.urlError
        }
        
        do {
            let fetchData = try await networkClient.fetch(url: fullUrl)
            
            guard let decodedMovies = try? JSONDecoder().decode(MoviesDetailModel.self, from: fetchData) else {
                throw MoviesLoaderError.decodeError
            }
            
            if decodedMovies.errorMessage.isEmpty {
                return decodedMovies.link
            } else {
                throw MoviesLoaderError.loadError(message: decodedMovies.errorMessage)
            }
        } catch {
            throw MoviesLoaderError.networkError
        }
    }
}
