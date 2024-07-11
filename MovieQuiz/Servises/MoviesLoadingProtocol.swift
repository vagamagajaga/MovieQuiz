//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 28.11.2022.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies() async throws -> MostPopularMovies
    func loadMoviesTrailerLink(id: String) async throws -> String
}
