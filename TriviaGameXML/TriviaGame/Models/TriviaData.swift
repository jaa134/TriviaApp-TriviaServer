//
//  QuestionData.swift
//  TriviaGame
//
//  Created by Jacob Alspaw on 4/4/19.
//  Copyright © 2019 EECS 345 Group. All rights reserved.
//

import Foundation

struct Trivia: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

struct ServerResponse: Codable {
    let response_code: Int
    let results: [Trivia]
}

class TriviaData {
    public static let singleton: TriviaData = TriviaData();
    
    private var urlSessionConfig: URLSessionConfiguration
    public private(set) var response: ServerResponse
    
    private init() {
        response = ServerResponse(response_code: -1, results: [Trivia]())
        urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.timeoutIntervalForRequest = 20
        urlSessionConfig.timeoutIntervalForResource = 10
    }
    
    func update(onNetworkError: @escaping ()->(), onDataError: @escaping ()->(), onSuccess: @escaping ()->()) {
        let url = URL(string: "https://trivia392.herokuapp.com/api/triviaXML")!
        
        let session = URLSession(configuration: urlSessionConfig)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("Error: HTTP request error...")
                onNetworkError()
                return
            }
            guard let data = data else {
                print("Error: No data to decode...")
                onDataError()
                return
            }
            //has an error, does not parse arrays with single items... :(
            guard let response = try? XMLDecoder().decode(ServerResponse.self, from: data) else {
                print("Error: Couldn't decode data into questions set...")
                onDataError()
                return
            }
            self.response = response
            onSuccess()
        }
        
        task.resume()
    }
}



