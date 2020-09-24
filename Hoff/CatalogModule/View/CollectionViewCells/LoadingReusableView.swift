//
//  LoadingView.swift
//  Hoff
//
//  Created by Рамазан on 23.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.darkGray
    }
    
}
