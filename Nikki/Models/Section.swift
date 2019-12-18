//
//  Section.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/19.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// 記事を月毎に分けるデータ
class Section: Object {
    @objc dynamic var area: String = ""
    // 子を指定
    let categorys = List<Category>()
}
