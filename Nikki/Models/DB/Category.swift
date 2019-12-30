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
    @objc dynamic var date: String = ""
    @objc dynamic var index: String = ""
    @objc dynamic var day: String = ""
    @objc dynamic var hours: String = ""
    @objc dynamic var sort = Date()
    // 子を指定
    var articles = List<Article>()
    
    convenience init(date: String, index: String, day: String, hours: String, sort: Date, articles: List<Article>) {
        self.init()
        self.date = date
        self.index = index
        self.day = day
        self.hours = hours
        self.sort = sort
        self.articles = articles
    }
    
}
