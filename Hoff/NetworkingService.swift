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
    // Возвращает значение Bool, сообщающее, все ли элементы загружены с сервера
    // Если данная проверка не нужна, можно не возвращать ничего
    func getCatalog(limit: String, offset: String, sortBy: String, onSuccess: @escaping (Catalog) -> Void, onFailure: @escaping (String) -> Void) -> Bool
}


class NetworkService: NetworkServiceProtocol {
    
    func getCatalog(limit: String, offset: String, sortBy: String, onSuccess: @escaping (Catalog) -> Void, onFailure: @escaping (String) -> Void) -> Bool {
        
        var urlComponents = URLComponents()
        
        var allLoaded = false
        
        urlComponents.scheme = "https"
        urlComponents.host = "hoff.ru"
        urlComponents.path = "/api/v2/get_products_new"
        urlComponents.queryItems = [
            URLQueryItem(name: "category_id", value: "320"),
            URLQueryItem(name: "sort_by", value: sortBy),
            URLQueryItem(name: "sort_type", value: "desc"),
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "offset", value: offset),
            URLQueryItem(name: "device_id", value: "3a7612bcc84813b5"),
            URLQueryItem(name: "isAndroid", value: "false"),
            URLQueryItem(name: "app_version", value: "1.8.16"),
            URLQueryItem(name: "location", value: "19")
        ]
        
        AF.request(urlComponents).responseData { (responce) in
            
            switch responce.result {
            case .success(let resultJSON):
                let resultData = try? JSONDecoder().decode(Catalog.self, from: resultJSON)
                // Если количество загруженных элементов меньше запрошенных, allLoaded = true
                if (resultData?.items.count ?? 0 < Int(limit) ?? 1) {
                    allLoaded = true
                }
                // Дополнительная проверка декодирования результата
                if let resultData = resultData {
                    onSuccess(resultData)
                } else {
                    print("Ошибка декодирования")
                }
            case .failure(let error):
                onFailure(error.localizedDescription)
            }
        }
        
        // Возвращаем значение Bool, сообщающее, все ли элементы загружены с сервера
        return allLoaded
    }
    
}
