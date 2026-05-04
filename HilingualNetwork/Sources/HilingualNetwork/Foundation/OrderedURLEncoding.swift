//
//  OrderedURLEncoding.swift
//  HilingualNetwork
//
//  Created by 조영서 on 7/16/25.
//

import Foundation
import Alamofire

public struct OrderedURLEncoding: ParameterEncoding {
    public init() {}

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        guard let url = request.url, let parameters = parameters else {
            return request
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems: [URLQueryItem] = []

        if let year = parameters["year"] {
            queryItems.append(URLQueryItem(name: "year", value: "\(year)"))
        }
        if let month = parameters["month"] {
            queryItems.append(URLQueryItem(name: "month", value: "\(month)"))
        }

        components?.queryItems = queryItems
        request.url = components?.url
        return request
    }
}
