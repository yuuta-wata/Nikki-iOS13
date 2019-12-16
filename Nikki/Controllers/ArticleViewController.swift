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
    // HomeViewControllerから渡されたCategoryデータを受け取る変数
    var selectedCategory: Category?
    
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
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // 受け取ったデータからリストを取得し、textに表示させる
    func loadArticle() {
        diaryTitle.text = selectedCategory?.articles.first?.title
        diaryContent.text = selectedCategory?.articles.first?.content
    }
}

// MARK: - TextField Delegate Methods
extension ArticleViewController: UITextFieldDelegate {
    // ユーザーに編集をさせない
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        return false
    }
}
// MARK: - TextView Delegate Methods
extension ArticleViewController: UITextViewDelegate {
    // ユーザーに編集をさせない
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
        return false
    }
}
