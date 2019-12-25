//
//  BaseViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/25.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // サイドナビゲーションの初期状態
    private var sideNavigationStatus: SideNavigationStatus = .closed

    @IBOutlet weak var sideNavigationContainer: UIView!
    @IBOutlet weak var mainContentsContainer: UIView!
    @IBOutlet weak var wrapperButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ベース画面の透明ボタンを設定
        wrapperButton.backgroundColor = UIColor.black
        wrapperButton.alpha = 0
        // タップするとナビゲーションバーを閉じるように、イベントを無効にする
        wrapperButton.isUserInteractionEnabled = false
    }
    
    // MARK: - private Function
    // サイドナビゲーションを閉じた状態から左側のドラックでコンテンツを開く際の処理
    @objc private func edgeTapGesture(sender: UIScreenEdgePanGestureRecognizer) {
        // ドラック中のサイドナビゲーション、メインコンテンツのタッチイベントを無効にする
        sideNavigationContainer.isUserInteractionEnabled = false
        mainContentsContainer.isUserInteractionEnabled = false
        // 移動量を取得する
        let move: CGPoint = sender.translation(in: mainContentsContainer)
        // メイン画面がスライド出来るように、X座標に移動量を加算
        wrapperButton.frame.origin.x         += move.x
        mainContentsContainer.frame.origin.x += move.x
        
        // Debug.
        //print("サイドナビゲーションが閉じた状態でのドラッグの加算量:\(move.x)")
        
        // サイドナビゲーションとボタンのアルファ値を変更
        sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 260
        wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 260 * 0.36
        // メイン画面のx座標が0〜260の間に収まるように補正
        if mainContentsContainer.frame.origin.x > 260 {
            mainContentsContainer.frame.origin.x = 260
            wrapperButton.frame.origin.x         = 260
        } else if mainContentsContainer.frame.origin.x < 0 {
            mainContentsContainer.frame.origin.x = 0
            wrapperButton.frame.origin.x         = 0
        }
        
        // ドラッグ終了時の処理
        /*
         境界値(x座標: 160)のところで開閉状態を決める
         ボタンエリアが開いた時の位置から変わらない時(x座標: 260)または境界値より前ではコンテンツを閉じる
         */
        if sender.state == UIGestureRecognizer.State.ended {
            if mainContentsContainer.frame.origin.x < 160 {
                
            }
        }
    }
    // コンテナの開閉状態を管理する
    private func changeContainerSettingWithAnimation(_ status: SideNavigationStatus) {
        // サイドナビゲーションが閉じてる状態で押された　→ コンテンツを開く
        if status == .opened {
            sideNavigationStatus = status
            executeSideOpenAnimation()
        // サイドナビゲーションが開いている状態で押された　→ コンテンツを閉じる
        } else {
            sideNavigationStatus = .closed
            executeSidecloseAnimation()
        }
    }
    
    // サイドナビゲーションを開くアニメーションを実行する
    private func executeSideOpenAnimation(withCompletion: (() -> ())? = nil) {
        // サイドナビゲーションのタッチイベントを有効にする
        self.sideNavigationContainer.isUserInteractionEnabled = true
        // メイン画面はタッチイベントを無効にする
        self.mainContentsContainer.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            // メイン画面を移動させてサイドナビゲーションを表示させる
            self.mainContentsContainer.frame = CGRect(
                x:      260,
                y:      self.mainContentsContainer.frame.origin.y,
                width:  self.mainContentsContainer.frame.width,
                height: self.mainContentsContainer.frame.height)
            self.wrapperButton.frame = CGRect(
                x:      260,
                y:      self.wrapperButton.frame.origin.y,
                width:  self.wrapperButton.frame.width,
                height: self.wrapperButton.frame.height)
            // メインコンテンツ以外のアルファを変更する
            self.wrapperButton.alpha           = 0.36
            self.sideNavigationContainer.alpha = 1
            
        }) { (_) in
            // 引数で受け取った完了時に行いたい処理を実行する
            withCompletion?()
        }
    }
    // サイドナビゲーションを閉じるアニメーションを実行する
    private func executeSidecloseAnimation(withCompletion: (() -> ())? = nil) {
        // サイドナビゲーションのタッチイベントを無効にする
        self.sideNavigationContainer.isUserInteractionEnabled = false
        // メイン画面はタッチイベントを有効にする
        self.mainContentsContainer.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut], animations: {
            // メイン画面を移動させてサイドナビゲーションを表示させる
            self.mainContentsContainer.frame = CGRect(
                x:      0,
                y:      self.mainContentsContainer.frame.origin.y,
                width:  self.mainContentsContainer.frame.width,
                height: self.mainContentsContainer.frame.height)
            self.wrapperButton.frame = CGRect(
                x:      0,
                y:      self.wrapperButton.frame.origin.y,
                width:  self.wrapperButton.frame.width,
                height: self.wrapperButton.frame.height)
            // メインコンテンツ以外のアルファを変更する
            self.wrapperButton.alpha           = 0
            self.sideNavigationContainer.alpha = 0
            
        }) { (_) in
            // 引数で受け取った完了時に行いたい処理を実行する
            withCompletion?()
        }
    }
}
