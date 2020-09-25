//
//  RelatedTVCell.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

class RelatedTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CatalogTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}




extension RelatedTVCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.presenter.catalog?.relatedCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedCVCell", for: indexPath) as? RelatedCVCell {
            if let text = delegate?.presenter.catalog?.relatedCategories[indexPath.item].name {
                
                itemCell.titleLabel.text = text
                itemCell.layer.cornerRadius = 4
                
                return itemCell
            }
        }
        return UICollectionViewCell()
    }
    
}




// MARK: - Cell Configurator

class RelatedTVCellConfigurator: ConfigurableTableViewCellProtocol {
    
    var delegate: CatalogTVCellDelegate
    
    init(delegate: CatalogTVCellDelegate) {
        self.delegate = delegate
    }
    
    func configure(cell: UITableViewCell, index: Int?) {
        let cell = cell as! RelatedTVCell
        cell.delegate = self.delegate
        
        // Настройка тени
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.04567101884)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 6
        
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
    }
    
    func cellIdentifier() -> String {
        return "relatedTVCell"
    }
    
    func cellHeight() -> CGFloat {
        return 48
    }
    
}
