//
//  HeaderTVCell.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

protocol HeaderTVCellDelegate {
    func showSortAlert()
}


class HeaderTVCell: UITableViewCell {
    
    @IBOutlet weak var sortButton: UIButton!
    
    var delegate: HeaderTVCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Отслеживание нотификаций для изменения названия кнопки 
        NotificationCenter.default.addObserver(self, selector: #selector(setSortButtonPopular), name: .setSortButtonPopular, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setSortButtonLowPrice), name: .setSortButtonLowPrice, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setSortButtonHightPrice), name: .setSortButtonHightPrice, object: nil)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func filterButtonAction(_ sender: Any) {
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        delegate?.showSortAlert()
    }
    
    
    // Функции для изменения названия кнопки. Вызываются через NotificationCenter
    
    @objc func setSortButtonPopular() {
        self.sortButton.setTitle("Сначала популярные", for: .normal)
    }
    
    @objc func setSortButtonLowPrice() {
        self.sortButton.setTitle("Сначала дешевые", for: .normal)
    }
    
    @objc func setSortButtonHightPrice() {
        self.sortButton.setTitle("Сначала дорогие", for: .normal)
    }
    
}



// MARK: - Конфигуратор ячейки

class HeaderTVCellConfigurator: ConfigurableTableViewCellProtocol {
    
    let delegate: HeaderTVCellDelegate
    
    init(delegate: HeaderTVCellDelegate) {
        self.delegate = delegate
    }
    
    func configure(cell: UITableViewCell, index: Int?) {
        let cell = cell as! HeaderTVCell
        cell.delegate = self.delegate
    }
    
    func cellIdentifier() -> String {
        return "headerTVCell"
    }
    
    func cellHeight() -> CGFloat {
        return 48
    }
    
}
