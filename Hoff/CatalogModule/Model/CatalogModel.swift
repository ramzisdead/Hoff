//
//  CatalogModel.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import Foundation


struct Catalog: Codable {
    var totalCount: Int
    // var plashka - хер пойми какой тип данных
    var items: [CatalogItem] // Закомментировал items чтобы принимать его отдельно с пагинацией
    var relatedCategories: [RelatedCategories]
    var categoryName: String
}


struct CatalogItem: Codable {
    var id: String
    var name: String
    var image: String
    var isFavorite: Bool
    var prices: Prices
    // var full_set_prices - хер пойми какой тип данных
    var isBestPrice: Bool
    // var tag - хер пойми какой тип данных
    var articul: String
    var rating: Double
    var numberOfReviews: Int
    var statusText: String
    var isAvailable: Bool
    //var images: [String]
    var categoryId: String
}


struct Prices: Codable {
    var new: Int
    var old: Int
}


struct RelatedCategories: Codable {
    var id: String
    var name: String
}
