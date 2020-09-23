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
    var sortBy: SortTypes { get set }
    func getItems()
    func reloadData()
}


enum SortTypes: String {
    case popular = "popular"
    case price = "price"
}


class CatalogPresenter: CatalogPresenterProtocol {
    
    
    
    
    let view: CatalogViewProtocol
    let networkService: NetworkServiceProtocol
    let router: RouterProtocol
    var catalog: Catalog? // Массив для последующего заполнения из getCatalog()
    
    // Пагинация
    private var isLoading = false
    private var allLoaded = false
    
    private var offset = "0" // Отступ от нулевого элемента. Количество, которое я уже загрузил
    private var limit = "10" // Количество, которое я запрашиваю с сервера в данный момент
    
    var sortBy: SortTypes = .popular {
        didSet {
            reloadData()
        }
    }
    
    
    required init(view: CatalogViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getItems()
    }
    
    
    func getItems() {
        // Если allLoaded == false и isLoading == false, тогда выполняем функцию
        guard !allLoaded && !isLoading  else { return }
        
        // На время выполнения функции ставим isLoading == true
        self.isLoading = true
        
        // Задаем значение allLoaded путем вызова функции из networkService
        self.allLoaded = networkService.getCatalog(limit: limit, offset: offset, sortBy: sortBy.rawValue, onSuccess: { [weak self] (catalog) in
            
            // Устанавливаем слабую ссылку на self для предотвращения утечки памяти
            // Прописываем проверку на существование self с помощью guard
            guard let self = self else { return }
            
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
            self.isLoading = false
        }, onFailure: { (error) in
            print(error)
            self.isLoading = false
        })
        
        // Прибавляем к общему количетсву загружженых элементов новые загружаемые
        self.offset = String(Int(self.offset)! + Int(self.limit)!)
    }
    
    
    func reloadData() {
        self.catalog?.items = []
        self.offset = "0"
        self.getItems()
    }
}
