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
