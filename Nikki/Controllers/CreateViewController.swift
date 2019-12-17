//
//  CreateViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/12.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class CreateViewController: ManagementKeyboardViewController {
    // Realmを取得
    let realm = try! Realm()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    // contentTextFieldの底側の制約を取得
    @IBOutlet weak var contentTextViewBottomConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // 画面を表示させる前に呼ばせる
    override func keyboardWillAppear(_ notification: Notification) {
        // キーボードのサイズを取得
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        // キーボードの高さを求めるための型定義
        let keyboardHeight: CGFloat
        // iOS13以上ならキーボードの高さを差し引いたTextViewを表示する
        if #available(iOS 13.0, *) {
            keyboardHeight = self.view.safeAreaInsets.bottom - keyboardFrame.cgRectValue.height
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        contentTextViewBottomConstraints.constant = keyboardHeight
    }
    // 画面を閉じる前に呼ばせる
    override func keyboardWillDisappear(_ notification: NSNotification?) {
        // contentTextFieldの高さを元に戻す
        contentTextViewBottomConstraints.constant = 0.0
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
                let newArticles = newCategory.articles
                // Categoryの子データであるArticleにタイトルとコンテンツを格納
                let article = Article()
                // titleTextFieldに値がなければ"No Title"を保存する
                article.title = titleTextField.text ?? "No Title"
                // contentTextFieldに値がなければ"No Content"を保存する
                article.content = contentTextView.text ?? "No Content"
                
                newArticles.append(article)
            }
        } catch {
            print("エラー\(error)")
        }
        // 保存
        save(category: newCategory)
        dismiss(animated: true, completion: nil)
        print("投稿完了")
    }

}
