//
//  Category.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// ホームで表示する記事データ
class Category: Object {
    @objc dynamic var index: String = ""
    // 子を指定
    let articles = List<Article>()
}
