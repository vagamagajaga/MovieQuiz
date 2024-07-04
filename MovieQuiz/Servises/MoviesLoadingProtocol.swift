//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 28.11.2022.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
    func loadMoviesTrailerLink(id: String) async throws -> String
}
