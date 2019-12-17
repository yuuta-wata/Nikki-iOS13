//
//  KeyBoardViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/17.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

class ManagementKeyboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboard()
    }
    // Viewに認証させる
    func setupHideKeyboard() {
        view.addGestureRecognizer(hideKeyboard())
    }
    // タップするとレスポンダーを破棄する
    func hideKeyboard() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        // タップがキャンセルされないようにする
        tap.cancelsTouchesInView = false
        return tap
    }
    

}
