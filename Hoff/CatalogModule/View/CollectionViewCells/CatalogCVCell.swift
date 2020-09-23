//
//  CatalogCVCell.swift
//  Hoff
//
//  Created by Рамазан on 04.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos


class CatalogCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    var currentItem: CatalogItem?
    
    func setData(item: CatalogItem) {
        
        currentItem = item
        
        // Изображения
        let imageURL = URL(string: item.image)
        imageView.sd_setImage(with: imageURL, completed: nil)
        imageWidthConstraint.constant = self.frame.width
        
        // Плашка лучшая цена / скидка
        self.discountLabel.layer.cornerRadius = 2
        self.discountLabel.textColor = .white
        
        if item.isBestPrice == true || item.prices.old <= item.prices.new {
            self.oldPriceLabel.isHidden = true
            self.discountLabel.isHidden = false
            self.discountLabel.layer.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7333333333, blue: 0, alpha: 1)
            self.discountLabel.text = "Лучшая цена" + "    "
        } else {
            if item.prices.old > item.prices.new {
                let discount = 100 - (item.prices.new * 100 / item.prices.old)
                self.oldPriceLabel.isHidden = false
                self.discountLabel.isHidden = false
                
                let oldPriseStriked = NSAttributedString(string: "\(item.prices.old)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                
                self.oldPriceLabel.attributedText = oldPriseStriked
                self.discountLabel.layer.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0, alpha: 1)
                self.discountLabel.text = "-\(discount)%" + "    "
            } else {
                self.oldPriceLabel.isHidden = true
                self.discountLabel.isHidden = true
            }
        }
        
        // Все остальные поля
        self.priceLabel.text = String(item.prices.new)
        self.titleLabel.text = item.name
        self.descriptionLabel.text = item.statusText
        self.cosmosView.rating = item.rating
        self.cosmosView.text = "(\(item.numberOfReviews))"
        
        // Проверка наличия в избранном
        if Favorite.shared.isFavorite(item: item) {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
    }
    
    
    // Кнопка избранного
    @IBAction func favoriteButtonAction(_ sender: Any) {
        
        guard let currentItem = self.currentItem else { return }
        
        if Favorite.shared.checkFavoriteOnClick(item: currentItem) {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart-empty"), for: .normal)
        }
    }
    
}
