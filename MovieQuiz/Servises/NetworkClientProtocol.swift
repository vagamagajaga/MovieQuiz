//
//  NetworkClientProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 06.12.2022.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
    func fetch(url: URL) async throws -> Data
}

