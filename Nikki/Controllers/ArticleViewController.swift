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
    
    // HomeViewControllerから渡されたDiaryListデータを受け取る変数
    var selectedDiaryLists = DiaryList()
    
    private let realm = try! Realm()
    
    private var texts = false
    // MARK: - UI Parts
    @IBOutlet weak var articleNavItem: UINavigationItem!
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var diaryContent: UITextView!
    
    @IBOutlet var toolBer: UIToolbar!
    // diaryContentの底側の制約を取得
    @IBOutlet weak var wrapperViewBottomConstraints: NSLayoutConstraint!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // ロード
        loadArticle()
        // TextFieldが選択されたら通知
        diaryTitle.delegate = self
        // TextViewが選択されたら通知
        diaryContent.delegate = self
        // ツールバーを追加
        diaryTitle.inputAccessoryView = toolBer
        diaryContent.inputAccessoryView = toolBer
        // 文字色を指定
        diaryTitle.textColor = UIColor(code: "333333")
        diaryContent.textColor = UIColor(code: "333333")
        
    }
    // 受け取ったデータからリストを取得し、textに表示させる
    private func loadArticle() {
        diaryTitle.text = selectedDiaryLists.articles.first?.title
        diaryContent.text = selectedDiaryLists.articles.first?.content
    }
    // 画面を表示させる前に呼ばせる
    override func keyboardWillAppear(_ notification: Notification) {
        // キーボードのサイズを取得
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        // キーボードの高さを求めるための型定義
        let keyboardHeight: CGFloat
        // iOS12以上ならキーボードとツールバーの高さを差し引いたTextViewを表示する
        if #available(iOS 12.0, *) {
            keyboardHeight = self.view.safeAreaInsets.bottom - (keyboardFrame.cgRectValue.height + toolBer.frame.height)
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        wrapperViewBottomConstraints.constant = keyboardHeight
    }
    // 画面を閉じる前に呼ばせる
    override func keyboardWillDisappear(_ notification: NSNotification?) {
        // Viewの高さを元に戻す
        wrapperViewBottomConstraints.constant = 0.0
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
                    selectedDiaryLists.index = diaryTitle.text ?? "No Title"
                    selectedDiaryLists.articles.first?.title = diaryTitle.text ?? "No Title"
                    selectedDiaryLists.articles.first?.content = diaryContent.text ?? "No Content"
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
    // 完了ボタン
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        // キーボードを閉じる
        diaryTitle.endEditing(true)
        diaryContent.endEditing(true)
    }
    
    // フォトライブラリボタン
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        // フォトライブラリを設定
        imagePicker.sourceType = .photoLibrary
        // フォトライブラリを呼ぶ
        present(imagePicker, animated: true, completion: nil)
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
