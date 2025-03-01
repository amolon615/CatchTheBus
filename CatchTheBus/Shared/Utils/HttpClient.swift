//
//  HttpClient.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//


import Foundation
import UIKit

final class HttpClient: Sendable {
    
    enum HttpError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError(DecodingError)
        case unauthorized
        case notFound
        case serverError(statusCode: Int)
        case clientError(statusCode: Int)
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL provided is invalid."
            case .noData:
                return "No data was returned from the request."
            case .decodingError(let decodingError):
                return "Failed to decode the response.\n\(decodingError.extendedDescription)"
                
            case .unauthorized:
                return "Unauthorized access. Please check your credentials."
            case .notFound:
                return "The requested resource was not found."
            case .serverError(let statusCode):
                return "Server error with status code \(statusCode). Please try again later."
            case .clientError(let statusCode):
                return "Client error with status code \(statusCode). Check your request."
            case .unknown(let error):
                return "An unknown error occurred: \(error.localizedDescription)"
            }
        }
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        accessToken: String? = nil
    ) async throws -> T {
        
        guard let url = URL(string: Constants.baseURL + endpoint) else {
            throw HttpError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let userAgent = await self.constructUserAgent()
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        if let body = body {
            request.httpBody = body
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HttpError.unknown(NSError(domain: "HTTPResponse", code: 0, userInfo: nil))
            }
            
            // Handle status codes
            switch httpResponse.statusCode {
            case 200..<300:
                break
            case 401:
                throw HttpError.unauthorized
            case 404:
                throw HttpError.notFound
            case 400..<500:
                throw HttpError.clientError(statusCode: httpResponse.statusCode)
            case 500..<600:
                throw HttpError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw HttpError.unknown(NSError(domain: "HTTPResponse",
                                                code: httpResponse.statusCode,
                                                userInfo: nil))
            }
            
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error as DecodingError {
                throw HttpError.decodingError(error)
            } catch {
                throw HttpError.unknown(error)
            }
        } catch let error as HttpError {
            throw error
        } catch {
            throw HttpError.unknown(error)
        }
    }
    
    private func constructUserAgent() async -> String {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "UnknownApp"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "UnknownVersion"
        let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "UnknownBuild"
        let systemName = await UIDevice.current.systemName
        let systemVersion = await UIDevice.current.systemVersion
        let deviceModel = await UIDevice.current.model
        
        let userAgent = "\(appName)/\(appVersion) (\(appBuild)); \(deviceModel); \(systemName) \(systemVersion)"
        return userAgent
    }
}

extension DecodingError {
    var extendedDescription: String {
        switch self {
        case .dataCorrupted(let context):
            return "[Data Corrupted] \(context.debugDescription)\nCoding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "->"))"
        case .keyNotFound(let key, let context):
            return "[Key Not Found] Key '\(key.stringValue)' not found: \(context.debugDescription)\nCoding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "->"))"
            
        case .valueNotFound(let type, let context):
            return "[Value Not Found] Value of type '\(type)' not found: \(context.debugDescription)\nCoding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "->"))"
            
        case .typeMismatch(let type, let context):
            return "[Type Mismatch] Type '\(type)' mismatch: \(context.debugDescription)\nCoding Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "->"))"
        @unknown default:
            return "[Unknown DecodingError] No further info."
        }
    }
}
