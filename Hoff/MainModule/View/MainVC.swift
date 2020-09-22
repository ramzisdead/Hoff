//
//  MainVC.swift
//  Hoff
//
//  Created by Рамазан on 02.09.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var presenter: MainPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    @IBAction func showCatalogAction(_ sender: Any) {
        presenter.showCatalogView()
    }
    
}


extension MainVC: MainViewProtocol {
    
}
