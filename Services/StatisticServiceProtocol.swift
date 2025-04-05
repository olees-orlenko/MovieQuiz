//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Олеся Орленко on 02.04.2025.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
