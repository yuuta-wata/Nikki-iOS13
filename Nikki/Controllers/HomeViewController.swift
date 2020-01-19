//
//  ViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/12.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    // MARK: - Properties
    // Realmを取得
    private let realm = try! Realm()
    // セクションに表示する日付を取得
    private let items = try! Realm().objects(Category.self).sorted(byKeyPath: "date", ascending: false)
    // String型にキャストし、降順にする
    private var sectionNames: [String] {
        return Set(items.value(forKeyPath: "date") as! [String]).sorted(by: > )
    }
    // セルに表示するデータを取得
    private var categorys: Results<Category>?
    
    // MARK: - UI Parts
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // DateSourceを設定
        tableView.dataSource = self
        // Delegateを設定
        tableView.delegate = self
        // カスタムセルを設定
        tableView.registerCustomCell()
        // セルの縦幅
        tableView.rowHeight = 100.0
    }
    // viewが画面に表示されてから呼ばれるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 画面が表示される度にロードする
        loadCategories()
    }
    
    
    // MARK: - Data Manipulation Methods
    // ロードメソッド
    private func loadCategories() {
        // Realmからデータをロード
        categorys = realm.objects(Category.self).sorted(byKeyPath: "cellIndicateDate", ascending: false)
        // テーブルビューをロード
        tableView.reloadData()
    }
}

// MARK: - TableView Datasource Methods
extension HomeViewController: UITableViewDataSource {
    
    // 表示するセクションの数を取得
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    // 取得したセクションの数に応じて表示
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    // セルを表示する行数を取得
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得した記事の日付と取得したセクションの日付が完全一致する数を取得
        return items.filter("date == %@", sectionNames[section]).count
    }
    // セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ListCell
        // セルを降順で表示し、セクションの日付毎に記事を表示させる
        cell.titleLabel.text = items.sorted(byKeyPath: "cellIndicateDate", ascending: false).filter("date == %@", sectionNames[indexPath.section])[indexPath.row].index
        // 時刻を代入
        cell.timeLabel.text = items.sorted(byKeyPath: "cellIndicateDate", ascending: false).filter("date == %@", sectionNames[indexPath.section])[indexPath.row].cellIndicateDate
        
        return cell
    }
    
    
}

// MARK: - TbaleView Delegate Methods
extension HomeViewController: UITableViewDelegate {
    
    // セルが選択されていることを通知する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルに指定した識別子でセグエを開始する
        performSegue(withIdentifier: K.categoryCell, sender: self)
        // セルをタッチした時に選択解除のアニメーションを追加
        tableView.deselectRow(at: indexPath, animated: true)
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
    // セルをスワイプで削除するメソッド
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
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
            tableView.reloadData()
            //            print("削除")
            success(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
