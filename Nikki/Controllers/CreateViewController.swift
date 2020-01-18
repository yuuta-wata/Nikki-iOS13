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
    // MARK: - Properties
    // Realmを取得
    private let realm = try! Realm()
    // 日付を取得するための変数
    private var sectionDate = ""
    private var day = ""
    private var cellIndicateDate = ""
    private var dayOfWeek = ""
    // MARK: - UI Parts
    @IBOutlet weak var createViewNavItem: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet var toolBar: UIToolbar!
    // WrapperViewの底側の制約を取得
    @IBOutlet weak var wrapperViewBottomConstraints: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDate()
        // 文字色を指定
        titleTextField.textColor = UIColor(code: "333333")
        contentTextView.textColor = UIColor(code: "333333")
        // ツールバーを設定
        titleTextField.inputAccessoryView = toolBar
        contentTextView.inputAccessoryView = toolBar
    }
    
    // 日付をロードする
    private func loadDate() {
        // 日付フォーマットを初期化
        let jpDateFormate = DateFormatter()
        // 日付を日本表記にする
        jpDateFormate.locale = Locale(identifier: "ja_JP")
        // 曜日を取得
        jpDateFormate.setLocalizedDateFormatFromTemplate("EEE")
        dayOfWeek = jpDateFormate.string(from: Date())
        
        let date = DateItems.Request.init(date: Date())
        day = "\(date.year)年\(date.month)月\(date.day)日"
        sectionDate = "\(date.year)年\(date.month)月"
        cellIndicateDate = "\(date.day)日(\(dayOfWeek))\(date.hour)時\(date.minute)分\(date.second)秒"
        // ナビゲーションタイトルに日付を表示
        createViewNavItem.title = "\(date.year)年\(date.month)月\(date.day)日\(date.hour)時\(date.minute)分\(date.second)秒"
    }
    
    // MARK: - TextView Size
    // 画面を表示させる前に呼ばせる
    override func keyboardWillAppear(_ notification: Notification) {
        // キーボードのサイズを取得
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            fatalError("キーボードのサイズを取得できません")
        }
        // キーボードの高さを求めるための型定義
        let keyboardHeight: CGFloat
        // iOS12以上ならキーボードの高さを差し引いたTextViewを表示する
        if #available(iOS 12.0, *) {
            keyboardHeight = self.view.safeAreaInsets.bottom - (keyboardFrame.cgRectValue.height + toolBar.frame.height)
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
    // 記事投稿ボタン
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try realm.write {
                // Articleの各データを取得
                let article = Article()
                // Categoryの各データを取得
                let newArticle = Category().articles
                // Articleに各データを代入
                article.title = titleTextField.text ?? "No Title"
                article.content = contentTextView.text ?? "No Content"
                // 代入したArticleデータをCategoryの子データに格納
                newArticle.append(article)
                // Categoryに各データを保存
                realm.add(Category(date: sectionDate,
                                   index: titleTextField.text ?? "No Title",
                                   day: day,
                                   cellIndicateDate: cellIndicateDate,
                                   dayOfWeek: dayOfWeek,
                                   articles: newArticle))
            }
            
        } catch {
            print("Post error\(error)")
        }
        dismiss(animated: true, completion: nil)
        //        print("投稿完了")
    }
    // 完了ボタン
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        // キーボードを閉じる
        titleTextField.endEditing(true)
        contentTextView.endEditing(true)
    }
    // フォトライブラリボタン
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        // フォトライブラリを設定
        imagePicker.sourceType = .photoLibrary
        // フォトライブラリを呼ぶ
        present(imagePicker, animated: true, completion: nil)
    }
    
}
