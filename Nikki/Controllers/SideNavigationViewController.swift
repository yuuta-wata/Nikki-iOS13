//
//  SideNavigationViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/25.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

protocol SideNavigationDelegate: NSObjectProtocol {
    
}

class SideNavigationViewController: UIViewController {

    weak var delegate: SideNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
