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
    // Categoryデータ型を宣言
    var categories: Results<Category>?
    
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
    // セルを表示する行数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // categoriesにデータがなければセルを１表示する
        return categories?.count ?? 1
    }
    // セルを作成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するセルを取得
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // catedoriesにデータがなければ"No Title"をセルテキストに代入
        cell.textLabel?.text = categories?[indexPath.row].index ?? "No Title"
        
        return cell
    }
    
    // MARK: - Data Manipulation Methods
    // ロードメソッド
    func loadCategories() {
        // Realmからデータをロード
        categories = realm.objects(Category.self)
        // テーブルビューをロード
        tableView.reloadData()
    }
    // スワイプで削除する
    override func deleteModel(at indexPath: IndexPath) {
        // 選択したセルにデータが入っていれば削除する
        if let categoryForDeletion = self.categories?[indexPath.row] {
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
                vc.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}
