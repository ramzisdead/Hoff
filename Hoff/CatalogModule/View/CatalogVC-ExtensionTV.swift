//
//  CatalogVC-ExtensionTV.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

extension CatalogVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellsArray.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellsArray[indexPath.row].cellIdentifier(), for: indexPath)
            cellsArray[indexPath.row].configure(cell: cell, index: indexPath.row)
            
            cell.selectionStyle = .none
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellsArray.count != 0 {
            return cellsArray[indexPath.row].cellHeight()
        }
        return 0
    }
    
}
