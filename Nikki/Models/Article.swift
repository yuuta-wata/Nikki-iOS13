//
//  Article.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// ユーザーが記入した記事データを保存するオブジェクト
class Article: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    // 親を指定
    var parentCategory = LinkingObjects(fromType: Category.self, property: "articles")
}
