//
//  CatalogVC.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

class CatalogVC: UIViewController, CatalogTVCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: CatalogPresenterProtocol!
    var cellsArray: [ConfigurableTableViewCellProtocol] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoading()
        
        self.navigationController?.navigationBar.tintColor = .black
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    
    func cellsArrayAppend() {
        cellsArray = []
        cellsArray.append(HeaderTVCellConfigurator(delegate: self))
        cellsArray.append(RelatedTVCellConfigurator(delegate: self))
        cellsArray.append(CatalogTVCellConfiguration(delegate: self, tableView: self.tableView))
    }
    
    
}



// MARK: - CatalogView Protocol

extension CatalogVC: CatalogViewProtocol {
    
    func succes() {
        cellsArrayAppend()
        tableView.reloadData()
    }
    
    
    func failure(error: Error) {
        print(error)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func reloadCollectionView() {
        NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
    }
    
    // Крутилка пагинации старт
    func showPageLoading() {
    }
    
    // Крутилка пагинации стоп
    func hidePageLoading() {
    }
}



// MARK: - HeaderTVCell Delegate

extension CatalogVC: HeaderTVCellDelegate {
    
    func showSortAlert(sortButtonTitle: @escaping (String) -> ()) {
        
        let alert = UIAlertController(title: "Сортировка", message: "", preferredStyle: .alert)
        
        let popular = "Сначала популярные"
        let popularAction = UIAlertAction(title: popular, style: .default) { (f) in
            self.presenter.sortBy = .popular
            sortButtonTitle(popular)
            NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
        }
        
        let hightPrice = "Сначала дорогие"
        let hightPriceAction = UIAlertAction(title: hightPrice, style: .default) { (f) in
            NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
            sortButtonTitle(hightPrice)
            self.presenter.sortBy = .price
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(popularAction)
        alert.addAction(hightPriceAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


