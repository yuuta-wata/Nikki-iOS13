//
//  ViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/12.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UITableViewController {
    // Realmを取得
    let realm = try! Realm()
    // Categoryデータ型を宣言
    var categories: Results<Category>?

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
        // 再利用するセルを作成
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        // catedoriesにデータがなければ"No Title"をセルテキストに代入
        cell.textLabel?.text = categories?[indexPath.row].title ?? "No Title"
        
        return cell
    }
    
    // MARK: - TbaleView Delegate Methods
    // セルが選択されていることを通知する
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルにアニメーションをつける
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Manipulation Methods
    // ロードメソッド
    func loadCategories() {
        // Realmからデータをロード
        categories = realm.objects(Category.self)
        // テーブルビューをロード
        tableView.reloadData()
    }
}
