//
//  CreateViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/12.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class CreateViewController: UIViewController {
    // Realmを取得
    let realm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 戻るボタン
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    // セーブメソッド
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("カテゴリ保存のエラー \(error)")
        }
    }
    
    // MARK: - Add New Items
    // 記事投稿ボタン
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        let newCategory = Category()
        // titleTextFieldに値がなければ"No Title"を保存する
        newCategory.title = titleTextField.text ?? "No Title"
        save(category: newCategory)
        print("投稿完了")
    }

}
