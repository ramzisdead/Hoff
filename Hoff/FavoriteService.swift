//
//  FavoriteService.swift
//  Hoff
//
//  Created by Рамазан on 13.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import Foundation


final class Favorite {
    
    // Singletone
    static let shared = Favorite()
    
    private let key = "ru.diit.hoff_test"
    private var catalog: [CatalogItem] = []
    
    
    // MARK: - Init
    
    private init() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let clothesFromDataBase = try? JSONDecoder().decode([CatalogItem].self, from: data) else { return }
        
        catalog.append(contentsOf: clothesFromDataBase)
    }
    
    
    // MARK: - Public methods
    
    func isFavorite(item: CatalogItem?) -> Bool {
        
        if let _ = catalog.firstIndex(where: { $0.id == item?.id}) {
            return true
        } else {
            return false
        }
    }
    
    
    func checkFavoriteOnClick(item: CatalogItem) -> Bool {
        
        if let index = catalog.firstIndex(where: { $0.id == item.id}) {
            catalog.remove(at: index)
            
            //обновление данных юзерфалс
            synchronize()
            return false
        } else {
            catalog.append(item)
            synchronize()
            return true
        }
    }
    
    
    func clear() {
        catalog.removeAll()
        synchronize()
    }
    
    
    /*func getFavorites() -> [CatalogItem] {
        return catalog
    }*/
    
    
    // MARK: - Private methods
    
    private func synchronize() {
        
        //обновление данных
        guard let clothes = try? JSONEncoder().encode(catalog) else { return }
        UserDefaults.standard.set(clothes, forKey: key)
    }
}

