//
//  NetworkService.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

fileprivate enum AccessKey: String {
    case unsplash = "eBW5tID8fSCIEp_8Tbk2-IeIKeH2AuVVVmv3_B38h8g"
}

protocol NetworkService {
    func searchPhotos(for query: String, page: Int) async throws -> [UnsplashPhoto]?
}

final class NetworkServiceImpl: NetworkService, HTTPDataDownloader {
    var decoder = JSONDecoder()
    let session: URLSession
    private let picturesPerPage = 30
    
    init(session: URLSession = .shared) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func searchPhotos(for query: String, page: Int) async throws -> [UnsplashPhoto]? {
        guard let request = createRequest(for: query, page: page) else { return nil }
        
        do {
            let photos = try await fetchData(as: [UnsplashPhoto].self, request: request)
            return photos
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknownError(error: error)
        }
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(AccessKey.unsplash.rawValue)"
        return headers
    }
    
    private func prepareParaments(searchTerm: String?, page: Int) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(page)
        parameters["per_page"] = String(picturesPerPage)
        return parameters
    }
    
    private func createUrl(with params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createRequest(for searchTerm: String,
                       page: Int) -> URLRequest? {
        let paramaters = prepareParaments(searchTerm: searchTerm, page: page)
        guard let url = createUrl(with: paramaters) else { return nil }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        return request
    }
}
