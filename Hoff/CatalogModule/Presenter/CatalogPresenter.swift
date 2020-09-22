//
//  Presenter.swift
//  Hoff
//
//  Created by Рамазан on 03.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import Foundation


protocol CatalogViewProtocol: class {
    func succes()
    func failure(error: Error)
    
    func showLoading()
    func hideLoading()
    
    func successLoadItems()
    
    func showPageLoading()
    func hidePageLoading()
}


protocol CatalogPresenterProtocol: class {
    init(view: CatalogViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    var catalog: Catalog? { get set }
    func getItems()
}


class CatalogPresenter: CatalogPresenterProtocol {
    
    let view: CatalogViewProtocol
    let networkService: NetworkServiceProtocol
    let router: RouterProtocol
    var catalog: Catalog? // Массив для последующего заполнения из getCatalog()
    
    // Пагинация
    var offset = "0" // Количество, которое я уже загрузил
    var limit = "10" // Количество, которое я запрашиваю с сервера
    var isLoading = false
    var allLoaded = false
    
    
    required init(view: CatalogViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getItems()
    }
    
    
    func getItems() {
        guard !allLoaded || !isLoading  else { return }
        
        // Просто showLoading не работает
        // Т.к. функция вызывается при инициализации презентера и у view еще нет его элементов
        if catalog == nil {
            //self.view.showLoading()
        } else {
            //self.view.showPageLoading()
        }
        
        self.isLoading = true
        self.offset = String(Int(self.offset)! + Int(self.limit)!)
        
        self.allLoaded = networkService.getCatalog(limit: limit, offset: offset, isLoading: isLoading, isAllLoaded: allLoaded, onSuccess: { (catalog) in
            // Если каталог не инициализирован, то инициализировать. Иначе пополнить массив итемов
            if self.catalog == nil {
                self.catalog = catalog
                
                self.view.succes()
                self.view.hideLoading()
            } else {
                self.catalog?.items += catalog.items
                
                self.view.successLoadItems()
                //self.view.hidePageLoading()
            }
        }, onFailure: { (error) in
            print(error)
        })
        
        self.isLoading = false
    }
    
}
