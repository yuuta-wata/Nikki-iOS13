//
//  Data.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift

// Realmモデルを定義
class Data: Object {
    dynamic var title: String = ""
    dynamic var content: String = ""
}
