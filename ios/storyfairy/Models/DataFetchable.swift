//
//  DataFetchable.swift
//  storyfairy
//
//  Created by Chunxu Yang on 8/20/23.
//

import Foundation
import Combine


enum FetchError: LocalizedError {
    case custom(error: Error)
    case failedToDecode
    case invalidBody
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Failed to decode response"
        case .invalidBody:
            return "Invalid data to send"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}

protocol DataFetchable: ObservableObject {
    associatedtype DataType: Decodable
    
    var data: DataType { get }
    var hasError: Bool { get }
    var error: FetchError? { get }
    var isRefreshing: Bool { get }
    
    func fetch() async
    func fetch(with params: Encodable?) async
    
    func cancelFetch()
}

class DataFetcher<DataType: Decodable>: DataFetchable, ObservableObject {
    
    
    @Published var data: DataType?
    @Published var hasError: Bool = false
    @Published var error: FetchError? = nil
    @Published var isRefreshing: Bool = false
    
    private var endpoint: ServerAPI
    private var cancellables = Set<AnyCancellable>()
    
    init(endpoint: ServerAPI) {
        self.endpoint = endpoint
    }
    
    func fetch() async {
        await fetch(with: nil)
        
    }
    
    func fetch(with params: Encodable?) async {
        DispatchQueue.main.async {
            self.isRefreshing = true
        }

        var request = endpoint.urlRequest

        if params != nil {
            guard let body = try? JSONEncoder().encode(params!) else {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = FetchError.invalidBody
                    self.isRefreshing = false
                }
                return
            }

            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            

            do {
                let result = try JSONDecoder().decode(DataType.self, from: data)
                

                DispatchQueue.main.async {
                    self.data = result
                    self.hasError = false
                    self.isRefreshing = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = FetchError.failedToDecode
                    self.isRefreshing = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                if let apiError = error as? APIError {
                    self.hasError = true
                    self.error = FetchError.custom(error: apiError)
                } else {
                    self.hasError = true
                    self.error = FetchError.custom(error: error)
                }
                self.isRefreshing = false
            }
        }
    }
    
    func cancelFetch() {
        self.isRefreshing = false
    }
}
