//
//  CatalogTVCell.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

protocol CatalogTVCellDelegate {
    var presenter: CatalogPresenterProtocol! {get set}
}


class CatalogTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CatalogTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Отслеживаение нотификации для перезагрузки CollectionView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadСollectionView), name: .reloadCatalogCV, object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Перезагрузка CollectionView
    @objc func reloadСollectionView() {
        collectionView.reloadData()
        collectionView.scrollsToTop = true
    }
    
}



class CatalogTVCellConfiguration: ConfigurableTableViewCellProtocol {
    
    var delegate: CatalogTVCellDelegate
    var tableView: UITableView
    
    init(delegate: CatalogTVCellDelegate, tableView: UITableView) {
        self.delegate = delegate
        self.tableView = tableView
    }
    
    
    func configure(cell: UITableViewCell, index: Int?) {
        let cell = cell as! CatalogTVCell
        cell.delegate = self.delegate
    }
    
    
    func cellIdentifier() -> String {
        return "catalogTVCell"
    }
    
    
    func cellHeight() -> CGFloat {
        let height = self.tableView.frame.height - 96
        return height
    }
    
}



extension CatalogTVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.presenter.catalog?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCVCell", for: indexPath) as? CatalogCVCell {
            
            if let item = delegate?.presenter.catalog?.items[indexPath.item] {
                
                itemCell.setData(item: item)
                
                itemCell.layer.cornerRadius = 4
                
                itemCell.layer.shadowPath = UIBezierPath(rect: itemCell.bounds).cgPath
                itemCell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.04567101884)
                itemCell.layer.shadowOpacity = 1
                itemCell.layer.shadowOffset = CGSize(width: 0, height: 2)
                itemCell.layer.shadowRadius = 6
                
                itemCell.clipsToBounds = false
                itemCell.layer.masksToBounds = false
                
                return itemCell
            }
            
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (delegate?.presenter.catalog?.items.count)! - 1 {
            delegate?.presenter.getItems()
        }
    }

}



extension CatalogTVCell: UICollectionViewDelegateFlowLayout {
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2
        let cellHeight = cellWidth * 1.8
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // Действие при нажатии на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print(indexPath.item)
    }
}

