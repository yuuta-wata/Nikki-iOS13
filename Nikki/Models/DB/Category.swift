//
//  Category.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/13.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation
import RealmSwift
// TableViewのcellに関連するオブジェクト
class Category: Object {
    @objc dynamic var date = ""
    @objc dynamic var index = ""
    @objc dynamic var day = ""
    @objc dynamic var hours = ""
    @objc dynamic var sort = ""
    // 子を指定
    var articles = List<Article>()
    
    convenience init(date: String, index: String, day: String, hours: String, sort: String, articles: List<Article>) {
        self.init()
        self.date = date
        self.index = index
        self.day = day
        self.hours = hours
        self.sort = sort
        self.articles = articles
    }
    
}
