//
//  BaseViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/25.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    // サイドナビゲーションの初期状態
    private var sideNavigationStatus: SideNavigationStatus = .closed
    // このViewControllerのタッチイベント開始時のx座標（コンテンツが開いた状態で仕込まれる）
    private var touchBeganPositionX: CGFloat!
    
    // MARK: - UI Parts
    @IBOutlet weak var sideNavigationContainer: UIView!
    @IBOutlet weak var mainContentsContainer: UIView!
    @IBOutlet weak var wrapperButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 一番最初に表示するViewController
        displayMainContantsViewController()
        // ベース画面の透明ボタン初期状態を設定
        wrapperButton.backgroundColor = UIColor.black
        wrapperButton.alpha = 0
        // タップするとナビゲーションバーを閉じるように、イベントを無効にする
        wrapperButton.isUserInteractionEnabled = false
        // 左隅部分のGestureRecognizerを作成する
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.edgeTapGesture(sender:)))
        // 左隅から開始させる
        leftEdgeGesture.edges = .left
        // 初期状態では左隅のGestureRecognizerを有効にする
        mainContentsContainer.addGestureRecognizer(leftEdgeGesture)
    }
    // MARK: - Setting Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.sideNavigationEmbedSegue {
            let sideNavigationViewController = segue.destination as! SideNavigationViewController
            sideNavigationViewController.delegate = self as? SideNavigationDelegate

        }
    }
    
    // MARK: - Touches Event
    // サイドナビゲーションが開いた状態：タッチイベントの開始時の処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // サイドナビゲーションが開いた際にタッチイベント開始位置のx座標を取得してメンバ変数に格納する
        let touchEvent = touches.first!
        // タッチイベント開始時のself.viewのx座標を取得する
        let beginPosition = touchEvent.previousLocation(in: self.view)
        touchBeganPositionX = beginPosition.x
        
        // Debug.
        print("サイドナビゲーションが開いた状態でのドラッグ開始時のx座標:\(String(describing: touchBeganPositionX))")
    }
    // サイドナビゲーションが開いた状態：タッチイベントの実行中の処理
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        /*
         タッチイベント開始位置のx座標がサイドナビゲーション幅より大きい場合
         メインコンテンツと透明ボタンをドラッグで動かすことができるようにする
         */
        if sideNavigationStatus == .opened && touchBeganPositionX >= 300 {
            // サイドナビゲーション及びメインコンテンツのタッチイベントを無効にする
            sideNavigationContainer.isUserInteractionEnabled = false
            mainContentsContainer.isUserInteractionEnabled = false
            
            let touchEvent = touches.first!
            // ドラック前の座標
            let preDx = touchEvent.previousLocation(in: self.view).x
            // ドラック後の座標
            let newDx = touchEvent.location(in: self.view).x
            // ドラックしたx座標の移動距離
            let dx = newDx - preDx
            // ドラッグした移動分の値を反映させる
            var viewFrame: CGRect = wrapperButton.frame
            viewFrame.origin.x += dx
            mainContentsContainer.frame = viewFrame
            wrapperButton.frame = viewFrame
            
            // Debug.
            print("サイドナビゲーションが開いた状態でのドラッグ中のx座標:\(viewFrame.origin.x)")
            
            // メインコンテンツのx座標が0〜300の間に収まるように補正
            if mainContentsContainer.frame.origin.x > 300 {

                mainContentsContainer.frame.origin.x = 300
                wrapperButton.frame.origin.x         = 300

            } else if mainContentsContainer.frame.origin.x < 0 {

                mainContentsContainer.frame.origin.x = 0
                wrapperButton.frame.origin.x         = 0
            }

            // サイドナビゲーションとボタンのアルファ値を変更する
            sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 300
            wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 300 * 0.36
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // タッチイベント終了時はメインコンテンツと透明ボタンの位置で開くか閉じるかを決める
        /**
        * 境界値(x座標: 160)のところで開閉状態を決める
        * ボタンエリアが開いた時の位置から変わらない時(x座標: 300)または境界値より前ではコンテンツを閉じる
        */
        if touchBeganPositionX >= 300 && (mainContentsContainer.frame.origin.x == 300 || mainContentsContainer.frame.origin.x < 160) {
            changeContainerSettingWithAnimation(.closed)
        } else if touchBeganPositionX >= 300 && mainContentsContainer.frame.origin.x >= 160 {
            changeContainerSettingWithAnimation(.opened)
        }
    }
    // メモリが少ない時に呼び出される
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SideNavigation Open Methods
    func openSideNavigation() {
        changeContainerSettingWithAnimation(.opened)
    }
    
    // MARK: - private Function
    // サイドナビゲーションを閉じた状態から左隅のドラックでコンテンツを開く際の処理
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
        print("サイドナビゲーションが閉じた状態でのドラッグの加算量:\(move.x)")
        
        // サイドナビゲーションとボタンのアルファ値を変更
        sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 300
        wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 300 * 0.36
        // メイン画面のx座標が0〜300の間に収まるように補正
        if mainContentsContainer.frame.origin.x > 300 {
            mainContentsContainer.frame.origin.x = 300
            wrapperButton.frame.origin.x         = 300
        } else if mainContentsContainer.frame.origin.x < 0 {
            mainContentsContainer.frame.origin.x = 0
            wrapperButton.frame.origin.x         = 0
        }
        
        // ドラッグ終了時の処理
        /*
         境界値(x座標: 50)のところで開閉状態を決める
         ボタンエリアが開いた時の位置から変わらない時(x座標: 300)または境界値より前ではコンテンツを閉じる
         */
        if sender.state == UIGestureRecognizer.State.ended {
            if mainContentsContainer.frame.origin.x < 50 {
                changeContainerSettingWithAnimation(.closed)
            } else {
                changeContainerSettingWithAnimation(.opened)
            }
        }
        // viewを指の動きに合わせて平行移動させる
        sender.setTranslation(CGPoint.zero, in: self.view)
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
                x:      300,
                y:      self.mainContentsContainer.frame.origin.y,
                width:  self.mainContentsContainer.frame.width,
                height: self.mainContentsContainer.frame.height)
            self.wrapperButton.frame = CGRect(
                x:      300,
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
    // 最初に表示させるViewControllerをメイン画面に埋め込む
    private func displayMainContantsViewController() {
        if let vc = UIStoryboard(name: "MainContents", bundle: nil).instantiateInitialViewController() {
            // ここで埋め込んでいる
            mainContentsContainer.addSubview(vc.view)
            // 埋め込んだViewが親になるとwrapperButtonが押せなくなるので、子Viewに設定する
            self.addChild(vc)
            // 子Viewに移動したら親Viewを表示する
            vc.didMove(toParent: self)
        }
    }
}
