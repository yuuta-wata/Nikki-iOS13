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

class HomeViewController: UITableViewController {
    // Realmを取得
    let realm = try! Realm()
    // Categoryデータ型を宣言
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 行の縦幅
        tableView.rowHeight = 80.0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SwipeTableViewCell
        // catedoriesにデータがなければ"No Title"をセルテキストに代入
        cell.textLabel?.text = categories?[indexPath.row].index ?? "No Title"
        
        cell.delegate = self
        
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
    
    // MARK: - TbaleView Delegate Methods
    // セルが選択されていることを通知する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルに指定した識別子でセグエを開始する
        performSegue(withIdentifier: K.categoryCell, sender: self)
        
    }
    // セグエ実行中の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("実行中")
        // 遷移先がArticleViewControllerなら選択しているCategoryデータをselectedCategoryに渡す
        if let vc = segue.destination as? ArticleViewController {
            print("成功1")
            if let indexPath = tableView.indexPathForSelectedRow {
                print("成功2")
                vc.selectedCategory = categories?[indexPath.row]
            }
        }
    }
}

// MARK: - SwipeCell Delegate Methods

extension HomeViewController: SwipeTableViewCellDelegate {
    // TableViewをスワイプで削除するときのメソッド
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // スワイプを右から指定
        guard orientation == .right else { return nil }
        
        // 削除するときのアクション処理
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("delete")
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
        // 削除アイコン
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
