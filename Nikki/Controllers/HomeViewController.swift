//
//  ViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/12.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class HomeViewController: SwipeTableViewController {
    // Realmを取得
    let realm = try! Realm()
    let items = try! Realm().objects(Section.self).sorted(by: ["area"])
    var sectionNames: [String] {
        return items.value(forKeyPath: "area") as! [String]
    }
    // Sectionデータ型を宣言
    var categorys: Results<Category>?
    @IBOutlet weak var homeNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // viewが画面に表示されてから呼ばれるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 画面が表示される度にロードする
        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    // 表示するセクションの数を取得
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    // 取得したセクションの数に応じて表示
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    // セルを表示する行数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // categoriesにデータがなければセルを１表示する
        return categorys?.count ?? 1
        // 取得したセクションareaデータが指定したareaと一致する
//        return items.filter("area == %@", sectionNames[section]).count
    }
    // セルを作成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するセルを取得
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // catedoriesにデータがなければ"No Title"をセルテキストに代入
        cell.textLabel?.text = categorys?[indexPath.row].index ?? "No Title"
//        cell.textLabel?.text = items.filter("area == %@", sectionNames[indexPath.section])[indexPath.row].area
        
        return cell
    }
    
    // MARK: - Data Manipulation Methods
    // ロードメソッド
    func loadCategories() {
        // Realmからデータをロード
        categorys = realm.objects(Category.self)
        // テーブルビューをロード
        tableView.reloadData()
    }
    // スワイプで削除する
    override func deleteModel(at indexPath: IndexPath) {
        // 選択したセルにデータが入っていれば削除する
        if let categoryForDeletion = self.categorys?[indexPath.row] {
            do {
                try! self.realm.write {
                    // 子データから削除する
                    self.realm.delete(categoryForDeletion.articles)
                    self.realm.delete(categoryForDeletion)
                }
            }
        }
    }
    
    // MARK: - TbaleView Delegate Methods
    // セルが選択されていることを通知する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルに指定した識別子でセグエを開始する
        performSegue(withIdentifier: K.categoryCell, sender: self)
        
    }
    // セグエ実行中の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先がArticleViewControllerなら選択しているCategoryデータをselectedCategoryに渡す
        if let vc = segue.destination as? ArticleViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedCategory = (categorys?[indexPath.row])!
            }
        }
    }
}
