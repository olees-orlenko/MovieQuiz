//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Олеся Орленко on 02.04.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func getBestResult(_ gameResult: GameResult) -> Bool {
        correct > gameResult.correct
    }
}
