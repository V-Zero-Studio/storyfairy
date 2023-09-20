//
//  ServerEndpoint.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/20/23.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

enum ServerAPI {
    case fetchCharacterChoices
    case fetchSceneChoices
    case fetchKeywordsChoices
    case fetchSlide
}

extension ServerAPI: APIBuilder {
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
        request.httpMethod = "POST"
        return request
    }
    
    var baseUrl: URL {
//        return URL(string: "http://127.0.0.1:8000")!
    }
    
    var path: String {
        switch self {
        case .fetchCharacterChoices:
            return "/characters/"
        case .fetchSceneChoices:
            return "/scenes/"
        case .fetchKeywordsChoices:
            return "/keywords/"
        case .fetchSlide:
            return "/slide/"
        }
    }
}


enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the object from the service"
        case .errorCode(let code):
            return "Error code \(code)"
        case .unknown:
            return "Unknown error"
        }
    }
}
