//
//  NetworkingService.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import Foundation
import Alamofire


protocol NetworkServiceProtocol {
    func getCatalog(limit: String, offset: String, isLoading: Bool, isAllLoaded: Bool, onSuccess: @escaping (Catalog) -> Void, onFailure: @escaping (String) -> Void) -> Bool
}


class NetworkService: NetworkServiceProtocol {
    
    func getCatalog(limit: String, offset: String, isLoading: Bool, isAllLoaded: Bool, onSuccess: @escaping (Catalog) -> Void, onFailure: @escaping (String) -> Void) -> Bool {
        
        var urlComponents = URLComponents()
        
        var allLoaded = false
        
        urlComponents.scheme = "https"
        urlComponents.host = "hoff.ru"
        urlComponents.path = "/api/v2/get_products_new"
        urlComponents.queryItems = [
            URLQueryItem(name: "category_id", value: "320"),
            URLQueryItem(name: "sort_by", value: "popular"),
            URLQueryItem(name: "sort_type", value: "desc"),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: offset),
            URLQueryItem(name: "device_id", value: "3a7612bcc84813b5"),
            URLQueryItem(name: "isAndroid", value: "true"),
            URLQueryItem(name: "app_version", value: "1.8.16"),
            URLQueryItem(name: "location", value: "19")
        ]
        
        AF.request(urlComponents).responseData { (responce) in
            switch responce.result {
            case .success(let resultJSON):
                let resultArray = try? JSONDecoder().decode(Catalog.self, from: resultJSON)
                if (resultArray?.items.count ?? 0 < Int(limit) ?? 0) {
                    allLoaded = true
                }
                onSuccess(resultArray!)
            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
        return allLoaded
    }
    
}
