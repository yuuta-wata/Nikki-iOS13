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
    var sectionDate = ""
    var cellWeek = ""
    var cellDay = ""
    var cellTime = ""
    
    @IBOutlet weak var createViewNavItem: UINavigationItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    // contentTextFieldの底側の制約を取得
    @IBOutlet weak var contentTextViewBottomConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDate()
    }
    
    // 日付をロードする
    func loadDate() {
        // 日付フォーマットを初期化
        let jpDateFormate = DateFormatter()
        // 日付を日本表記にする
        jpDateFormate.locale = Locale(identifier: "ja_JP")
        // タイムゾーンに日本を設定
        if let timeZone = TimeZone(identifier: "Asia/Tokyo") {
            // 日付の表示方法を指定
            jpDateFormate.setLocalizedDateFormatFromTemplate("ydMMMEEE jm")
            jpDateFormate.timeZone = timeZone
            // 日付を表示
            createViewNavItem.title = jpDateFormate.string(from: Date())
            // section用の日付を取得
            jpDateFormate.setLocalizedDateFormatFromTemplate("yMMMM")
            sectionDate = jpDateFormate.string(from: Date())
            print(sectionDate)
            // cell用の曜日を取得
            jpDateFormate.setLocalizedDateFormatFromTemplate("EEEEE")
            cellWeek = jpDateFormate.string(from: Date())
            print(cellWeek)
            // cell用の日付を取得
            jpDateFormate.setLocalizedDateFormatFromTemplate("dd")
            cellDay = jpDateFormate.string(from: Date())
            print(cellDay)
            // cell用の時刻を取得
            jpDateFormate.setLocalizedDateFormatFromTemplate("jm")
            cellTime = jpDateFormate.string(from: Date())
            print(cellTime)
        }
    }
    
    // 戻るボタン
    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextView Size
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
    
    // MARK: - Data Manipulation Methods
    // セーブメソッド
    func save(section: Section) {
        do {
            try realm.write {
                realm.add(section)
            }
        } catch {
            print("カテゴリ保存のエラー \(error)")
        }
    }
    
    // MARK: - Add New Items
    // 記事投稿ボタン
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try realm.write {
                // Sectionにデータを保存
                realm.add(Section(area: sectionDate), update: .modified)
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
                realm.add(Category(index: titleTextField.text ?? "No Title",
                                   date: sectionDate,
                                   week: cellWeek,
                                   day: cellDay,
                                   time: cellTime,
                                   articles: newArticle))
            }
            
        } catch {
            print("Post error\(error)")
        }
        // 保存
        //        save(section: newSection)
        dismiss(animated: true, completion: nil)
        print("投稿完了")
    }
    
}
