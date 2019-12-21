//
//  Section.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/19.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// TableViewのsectionで使うオブジェクト
class Section: Object {
    // 記事を月毎に分けるデータ
    @objc dynamic var area: String = ""

    convenience init(area: String) {
        self.init()
        self.area = area
    }
    // 子を指定
//    var categorys = List<Category>()
    // 主キーを設定
    override static func primaryKey() -> String? {
        return "area"
    }
}
