//
//  HeaderTVCell.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

protocol HeaderTVCellDelegate {
    func showSortAlert(sortButtonTitle: @escaping (String) -> ())
}


class HeaderTVCell: UITableViewCell {
    
    @IBOutlet weak var sortButton: UIButton!
    
    var delegate: HeaderTVCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func filterButtonAction(_ sender: Any) {
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        delegate?.showSortAlert(sortButtonTitle: { [weak self] title in
            guard let self = self else { return }
            self.sortButton.setTitle(title, for: .normal)
        })
    }

}




// MARK: - Cell Configurator

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
