//
//  HTTPDataDownloader.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation


protocol HTTPDataDownloader {
    var decoder: JSONDecoder { get }
    func fetchData<T: Decodable>(as type: T.Type, request: URLRequest) async throws -> T
}

extension HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        do {
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badServiceResponse(response: response.description)
            }
            
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidStatusCode(statusCode: response.statusCode)
            }
            let decoded = try decoder.decode(type, from: data)
            return decoded
        } catch let error as NetworkError {
            throw error
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.noInternet
            } else {
                throw NetworkError.unknownError(error: error)
            }
        }
    }
}

