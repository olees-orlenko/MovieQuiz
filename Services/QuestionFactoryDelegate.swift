//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Олеся Орленко on 31.03.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
