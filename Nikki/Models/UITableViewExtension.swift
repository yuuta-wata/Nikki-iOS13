//
//  UITableViewExtension.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/30.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerCustomCell() {
        register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
}
