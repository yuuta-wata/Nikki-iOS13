//
//  SwipeTableViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/16.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

//import UIKit
//import SwipeCellKit

//class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
//    // TableView Datasource Methods
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SwipeTableViewCell
//        // セルを作成したらSwipeTableViewControllerに通知
//        cell.delegate = self
//        
//        return cell
//    }
//    
//    // TableViewをスワイプで削除するときのメソッド
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        // スワイプを右から指定
//        guard orientation == .right else { return nil }
//        // 削除するときのアクション処理
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            self.deleteModel(at: indexPath)
//        }
//        // 削除アイコン
//        deleteAction.image = UIImage(named: "delete-icon")
//        
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
//    
//    func deleteModel(at indexPath:IndexPath) {
//        // データモデルを削除するメソッド
//        // HomeViewControllerでオーバーライドしてる
//    }

//}
