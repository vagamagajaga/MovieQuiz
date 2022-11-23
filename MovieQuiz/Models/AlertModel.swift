//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 10.11.2022.
//

import UIKit
import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let buttonText: String?
    
    let completion: () -> Void?
}
