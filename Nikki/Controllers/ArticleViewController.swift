//
//  ArticleViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/14.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleViewController: ManagementKeyboardViewController {
    // MARK: - Properties
    let realm = try! Realm()
    // HomeViewControllerから渡されたCategoryデータを受け取る変数
    var selectedCategory = Category()
    
    var texts = false
    // MARK: - UI Parts
    @IBOutlet weak var articleNavItem: UINavigationItem!
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var diaryContent: UITextView!
    // diaryContentの底側の制約を取得
    @IBOutlet weak var diaryContentBottomConstraints: NSLayoutConstraint!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // ロード
        loadArticle()
        // TextFieldが選択されたら通知
        diaryTitle.delegate = self
        // TextViewが選択されたら通知
        diaryContent.delegate = self
        // 文字色を指定
        diaryTitle.textColor = UIColor(code: "333333")
        diaryContent.textColor = UIColor(code: "333333")
        
    }
    // 受け取ったデータからリストを取得し、textに表示させる
    func loadArticle() {
        diaryTitle.text = selectedCategory.articles.first?.title
        diaryContent.text = selectedCategory.articles.first?.content
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
        diaryContentBottomConstraints.constant = keyboardHeight
    }
    // 画面を閉じる前に呼ばせる
    override func keyboardWillDisappear(_ notification: NSNotification?) {
        // diaryContentの高さを元に戻す
        diaryContentBottomConstraints.constant = 0.0
    }
    
    // MARK: - Setting Button Items
    // 戻るボタン
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // 編集ボタン
    @IBAction func editingButtonPressed(_ sender: UIBarButtonItem) {
        // 記事の編集
        if texts == false {
            texts = true
            // バックカラーを変更
            diaryTitle.backgroundColor = UIColor(code: "FFFAFA")
            diaryContent.backgroundColor = UIColor(code: "FFFAFA")
            sender.title = "完了"
        } else {
            // 記事をアップデートする
            do {
                try realm.write {
                    selectedCategory.index = diaryTitle.text ?? "No Title"
                    selectedCategory.articles.first?.title = diaryTitle.text ?? "No Title"
                    selectedCategory.articles.first?.content = diaryContent.text ?? "No Content"
                }
            } catch {
                print("アップデートエラー\(error)")
            }
            // バックカラーを戻す
            diaryTitle.backgroundColor = UIColor(code: "FFF4E2")
            diaryContent.backgroundColor = UIColor(code: "FFF4E2")
            sender.title = "編集"
            texts = false
        }
    }
    
}

// MARK: - TextField Delegate Methods
extension ArticleViewController: UITextFieldDelegate {
    // 初期状態ではユーザーにタイトルの編集をさせない
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return texts
    }
}
// MARK: - TextView Delegate Methods
extension ArticleViewController: UITextViewDelegate {
    // 初期状態ではユーザーにコンテンツの編集をさせない
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return texts
    }
}
