//
//  WebService.swift
//  SpectrumClub
//
//  Created by Koteswar_Rao on 30/12/19.
//  Copyright © 2019 Koteswar_Rao. All rights reserved.
//

import Foundation
import SystemConfiguration

class WebService {
    
    public static let shared = WebService()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://next.json-generator.com/api/json/get")!
    
    public enum APIServiceError: Error {
        case noNetwork
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
       return jsonDecoder
    }()
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard isConnectedToNetwork() else {
           completion(.failure(.noNetwork))
            return
        }
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
     
        urlSession.dataTask(with: url) { (result) in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        completion(.failure(.decodeError))
                    }
            case .failure(_):
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
    func fetchCompanies(with endPoint: String, result: @escaping (Result<Company, APIServiceError>) -> Void) {
        let companiesURL = baseURL
            .appendingPathComponent(endPoint)
        fetchResources(url: companiesURL, completion: result)
    }
    
    //helper method to check for network reachabilty.
    /**
     * --------- Network Connection Check
     **/
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
        if let error = error {
            result(.failure(error))
            return
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        result(.success((response, data)))
    }
}
}
