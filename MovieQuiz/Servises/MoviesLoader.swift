//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation



struct MoviesLoader: MoviesLoadingProtocol {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var moviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_r0f51fxi") else {
            preconditionFailure("Unable to construct moviesUrl")
        }
        return url
    }
    
    
    
    
    
    func loadMovies(handler: @escaping (Result<Movie, Error>) -> Void) {
        networkClient.fetch(url: moviesUrl) { <#Result<Data, Error>#> in
            <#code#>
        }
            
        }
    
    }

