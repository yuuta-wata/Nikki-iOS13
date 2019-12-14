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
    @IBOutlet weak var contentTextField: UITextView!
    
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
        // indexデータにタイトルを格納
        newCategory.index = titleTextField.text ?? "No Title"
        do {
            try realm.write {
                // Categoryの子データであるArticleにタイトルとコンテンツを格納
                let article = Article()
                let newArticles = newCategory.articles
                // titleTextFieldに値がなければ"No Title"を保存する
                article.title = titleTextField.text ?? "No Title"
                // contentTextFieldに値がなければ"No Content"を保存する
                article.content = contentTextField.text ?? "No Content"
                
                newArticles.append(article)
            }
        } catch {
            print("エラー\(error)")
        }
        // 保存
        save(category: newCategory)
        print("投稿完了")
    }

}
