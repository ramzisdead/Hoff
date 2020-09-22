//
//  AssemblyBuilder.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit


protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createCatalogModule(router: RouterProtocol) -> UIViewController
}


class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "MainStoryboard") as MainVC
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        view.title = ""
        return view
    }
    
    func createCatalogModule(router: RouterProtocol) -> UIViewController {
        let storyboard = UIStoryboard(name: "Catalog", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "CatalogStoryboard") as CatalogVC
        let networkService = NetworkService()
        let presenter = CatalogPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        view.title = "Угловые диваны"
        return view
    }

}
