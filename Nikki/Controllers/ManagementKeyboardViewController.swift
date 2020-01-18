//
//  KeyBoardViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/17.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

class ManagementKeyboardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // デリゲートを設定
        imagePicker.delegate = self
    }
    // MARK: - NSNotification Methods
    // Viewが表示される直前に呼ばれるメソッド
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // オブサーバーに追加する
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    // viewが閉じられる直前に呼ばれるメソッド。
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // オブサーバーに登録したオブジェクトを削除する
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        // CreateViewControllerでオーバーライドする
    }
    @objc func keyboardWillDisappear(_ notification: NSNotification?) {
        // CreateViewControllerでオーバーライドする
    }
    
    // MARK: - UITapGesturRecognizer Methods
    // Viewに認証させる
    private func setupView() {
        view.addGestureRecognizer(hideKeyboardViewTap())
    }
    // 画面をタップするとレスポンダーを破棄する
    private func hideKeyboardViewTap() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        // タップがキャンセルされないようにする
        tap.cancelsTouchesInView = false
        return tap
    }
}
