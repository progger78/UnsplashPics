//
//  NetworkService.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

fileprivate enum AccessKey: String {
    case unsplash = "E1QH66FDUtJadMoLHMiNJiF1slF9ES_3pCipuYNA23M"
}

protocol NetworkService {
    func searchPhotos(for searchTerm: String,
                      with filters: [URLQueryItem]?,
                      page: Int) async throws -> SearchResponse?
    func fetchMorePhotos(page: Int) async throws -> Any? 
    func loadDetailPhoto(for id: String) async throws -> DetailPhoto?
    func fetchInitialPhotos(page: Int) async throws -> [DetailPhoto]?
    var lastRequestType: NetworkServiceImpl.LastRequestType { get set }
}

final class NetworkServiceImpl: NetworkService, HTTPDataDownloader {
    
    enum Constants: String {
        case baseUrl = "https://api.unsplash.com"
        case searchPath = "/search/photos"
        case randomPhotosPath = "/photos"
    }
    
    enum LastRequestType {
        case search(searchTerm: String, filters: [URLQueryItem]?)
        case initialLoad
        case none
    }
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    var lastRequestType: LastRequestType = .none
    
    private let picturesPerPage = 30
    
    init(session: URLSession = .shared) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchInitialPhotos(page: Int) async throws -> [DetailPhoto]? {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(picturesPerPage))
        ]
        
        let photos: [DetailPhoto]? = try await makeRequest(path: Constants.randomPhotosPath.rawValue, queryItems: queryItems)
        lastRequestType = .initialLoad
        return photos
    }
    
    func searchPhotos(for searchTerm: String,
                      with filters: [URLQueryItem]? = nil,
                      page: Int) async throws -> SearchResponse? {
        
        var queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(picturesPerPage))
        ]
        
        if let filters {
            queryItems.append(contentsOf: filters)
        } else {
            queryItems.append(URLQueryItem(name: "query", value: searchTerm))
        }
        
        let photos: SearchResponse? = try await makeRequest(path: Constants.searchPath.rawValue, queryItems: queryItems)
        
        lastRequestType = .search(searchTerm: searchTerm, filters: filters)
        return photos
    }
    
    private func makeRequest<T: Decodable>(path: String, queryItems: [URLQueryItem]?) async throws -> T? {
        
        guard var components = URLComponents(string: Constants.baseUrl.rawValue + path) else { return nil }
        
        components.queryItems = queryItems
        
        guard let url = components.url else { throw NetworkError.invalidUrl }
        
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        
        return try await fetchData(as: T.self, request: request)
    }
    
    func loadDetailPhoto(for id: String) async throws -> DetailPhoto? {
        let path = "/photos/\(id)"
        let detailPhoto: DetailPhoto? = try await makeRequest(path: path, queryItems: nil)
        
        return detailPhoto
    }
    
    func fetchMorePhotos(page: Int) async throws -> Any? {
        switch lastRequestType {
        case .search(let searchTerm, let filters):
            return try await searchPhotos(for: searchTerm, with: filters, page: page)
        case .initialLoad:
            return try await fetchInitialPhotos(page: page)
        case .none:
            return nil
        }
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(AccessKey.unsplash.rawValue)"
        headers["Accept-Encoding"] = "gzip, deflate, identity"
        return headers
    }
}
