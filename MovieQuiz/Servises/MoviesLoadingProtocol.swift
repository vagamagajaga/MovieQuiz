//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 28.11.2022.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<Movie, Error>) -> Void)
}
