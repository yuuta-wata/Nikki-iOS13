//
//  ArticleViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/14.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift

class ArticleViewController: UIViewController {
    let realm = try! Realm()
    // HomeViewControllerから渡されたCategoryデータを受け取る変数
    var selectedCategory: Category?
    
    var texts = false
    
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var diaryContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TextFieldが選択されたら通知
        diaryTitle.delegate = self
        // TextViewが選択されたら通知
        diaryContent.delegate = self
        // ロード
        loadArticle()
    }
    // 戻るボタン
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // 編集ボタン
    @IBAction func editingButtonPressed(_ sender: UIBarButtonItem) {
        // 記事の編集
        if texts == false {
            texts = true
            sender.title = "完了"
        } else {
            // キーボードを下げる
            diaryTitle.resignFirstResponder()
            diaryContent.resignFirstResponder()
            texts = false
            sender.title = "編集"
            // 記事をアップデートする
            do {
                try realm.write {
                    selectedCategory?.index = diaryTitle.text ?? "No Title"
                    selectedCategory?.articles.first?.title = diaryTitle.text ?? "No Title"
                    selectedCategory?.articles.first?.content = diaryContent.text ?? "No Content"
                }
            } catch {
                print("エラー\(error)")
            }
            
        }
    }
    // 受け取ったデータからリストを取得し、textに表示させる
    func loadArticle() {
        diaryTitle.text = selectedCategory?.articles.first?.title
        diaryContent.text = selectedCategory?.articles.first?.content
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
