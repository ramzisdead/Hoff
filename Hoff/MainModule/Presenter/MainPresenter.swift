//
//  Presenter.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    
}


protocol MainPresenterProtocol {
    init(view: MainViewProtocol, router: RouterProtocol)
    func showCatalogView()
}


class MainPresenter: MainPresenterProtocol {
    
    let view: MainViewProtocol
    let router: RouterProtocol
    
    required init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showCatalogView() {
        self.router.showCatalog()
    }
    
}
