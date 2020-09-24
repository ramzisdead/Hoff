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
    
    // Для данных
    var delegate: CatalogTVCellDelegate?
    
    // Для футера
    var loadingView: LoadingReusableView?
    var isLoading = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Регистрируем ячейку
        let catalogCVCellNib = UINib(nibName: "CatalogCVCell", bundle: nil)
        collectionView.register(catalogCVCellNib, forCellWithReuseIdentifier: "catalogCVCell")
        
        // Регистрируем Nib футера в Collection View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        
        // Отслеживаение нотификации для перезагрузки CollectionView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadСollectionView), name: .reloadCatalogCV, object: nil)
        
        self.collectionView.reloadData()
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



// MARK: - Collection View Extension

extension CatalogTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.presenter.catalog?.items.count ?? 0
    }
    
    
    // Настройка ячейки
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
    
    
    // Действие при нажатии на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print(indexPath.item)
    }
    
    
    // Размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2
        let cellHeight = cellWidth * 1.8

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    // Подгрузка новых данных при появлении на экране (willDisplay) ячейки
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (delegate?.presenter.catalog?.items.count)! - 2 && !self.isLoading {
            loadMoreData()
        }
    }
    
    
    // MARK: - Footer с индикатором загрузки UICollectionView
    
    // Вызов подгрузки данных из презентера
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Специальная адержка загрузки
                sleep(2)
                
                self.delegate?.presenter.getItems()
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    
    // Задаем размер футера
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if (delegate?.presenter.allLoaded)! {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    
    // Возврат самого футера
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    
    // Включаем крутилку при появлении футера
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    
    // Выключаем крутилку при сокрытии футера
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
}




// MARK: - Cell Configurator

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
