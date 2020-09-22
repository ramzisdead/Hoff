//
//  ConfigurableTableViewCellProtocol.swift
//  Hoff
//
//  Created by Рамазан on 11.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

protocol ConfigurableTableViewCellProtocol {
    
    func cellHeight() -> CGFloat
    func configure(cell: UITableViewCell, index: Int?)
    func cellIdentifier() -> String
    
}


extension ConfigurableTableViewCellProtocol {
    
    func cellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
