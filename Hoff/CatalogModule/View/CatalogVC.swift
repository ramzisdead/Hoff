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
        activityIndicator.isHidden = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func successLoadItems() {
        NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
    }
    
    func showPageLoading() {
        // Крутилка пагинации старт
    }
    
    func hidePageLoading() {
        // Крутилка пагинации стоп 
    }
}



// MARK: - HeaderTVCell Delegate

extension CatalogVC: HeaderTVCellDelegate {
    
    func showSortAlert() {
        
        let alert = UIAlertController(title: "Сортировка", message: "", preferredStyle: .alert)
        
        let popularAction = UIAlertAction(title: "Сначала популярные", style: .default) { (f) in
            self.presenter.catalog?.items.sort(by: {$0.numberOfReviews > $1.numberOfReviews})
            NotificationCenter.default.post(name: .setSortButtonPopular, object: nil)
            NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
        }
        
        let lowPriceAction = UIAlertAction(title: "Сначала дешевые", style: .default) { (f) in
            self.presenter.catalog?.items.sort(by: {$0.prices.new < $1.prices.new})
            NotificationCenter.default.post(name: .setSortButtonLowPrice, object: nil)
            NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
        }
        
        let hightPriceAction = UIAlertAction(title: "Сначала дорогие", style: .default) { (f) in
            self.presenter.catalog?.items.sort(by: {$0.prices.new > $1.prices.new})
            NotificationCenter.default.post(name: .setSortButtonHightPrice, object: nil)
            NotificationCenter.default.post(name: .reloadCatalogCV, object: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(popularAction)
        alert.addAction(lowPriceAction)
        alert.addAction(hightPriceAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}


