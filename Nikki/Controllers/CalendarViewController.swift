//
//  CalendarViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/29.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // MARK: - Properties
    private let realm = try! Realm()
    private var diaryLists: Results<DiaryList>?
    private var day = ""
    private let dayOfWeek = ["日", "月", "火", "水", "木", "金", "土"]
    private var dayOfWeekCount = 0
    private var dayOfWeekColorCount = 0
    private var dayColorCount = 0
    // MARK: - UI Parts
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // FSCalendarを設定
        calendar.dataSource = self
        calendar.delegate = self
        // DateSourceを設定
        tableView.dataSource = self
        // Delegateを設定
        tableView.delegate = self
        // 年月を日本表記に変更
        calendar.appearance.headerDateFormat = "y年MM月"
        // ロード
        loadCategories()
        
        settingWeek()
        settingWeekColor()
        // カスタムセルを設定
        tableView.registerCustomCell()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadCategories()
    }
    // ロードメソッド
    private func loadCategories() {
        // Realmからデータをロード
        diaryLists = realm.objects(DiaryList.self).sorted(byKeyPath: "date", ascending: false)
        // テーブルビューをロード
        tableView.reloadData()
        // カレンダーをロード
        calendar.reloadData()
    }
    // MARK: - Setting
    // 曜日を日本表記に変更
    private func settingWeek() {
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = dayOfWeek[dayOfWeekCount]
            dayOfWeekCount += 1
        }
    }
    // 曜日毎に色を変更
    private func settingWeekColor() {
        for i in 0...6 {
            switch dayOfWeekColorCount {
            case 0:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.red
                dayOfWeekColorCount += 1
            case 6:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.blue
            default:
                calendar.calendarWeekdayView.weekdayLabels[i].textColor = UIColor.black
                dayOfWeekColorCount += 1
            }
        }
    }
    // MARK: - FSCalendar DataSource Methods
    // 投稿がある日にデータを反映させる
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let eventDate = DateItems.Request.init(date: date)
        let eventDay = "\(eventDate.year)年\(eventDate.month)月\(eventDate.day)日"
        return diaryLists?.filter("day == %@", eventDay).count ?? 0
    }
    
    // MARK: - FSCalendar Delegate Methods
    // カレンダーの日付をタップした時のアクション
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // タップした日付を取得
        let selectDay = DateItems.Request.init(date: date)
        day = "\(selectDay.year)年\(selectDay.month)月\(selectDay.day)日"
        tableView.reloadData()
    }
    
}
// MARK: - UITableView DataSource Methods
extension CalendarViewController: UITableViewDataSource {
    // 表示するセルを数える
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得した記事の日付とカレンダーの日付が完全一致する数を取得し、何もなければ１とする
        return diaryLists?.filter("day == %@", day).count ?? 1
    }
    // セル生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ListCell
        
        cell.titleLabel.text = diaryLists?.sorted(byKeyPath: "cellIndicateDate", ascending: false)
            .filter("day == %@", day)[indexPath.row].index ?? "No Title"
        
        cell.timeLabel.text = diaryLists?.sorted(byKeyPath: "cellIndicateDate", ascending: false)
            .filter("day == %@", day)[indexPath.row].cellIndicateDate ?? ""
        
        return cell
    }
    
    
}
// MARK: - UITableView Delegate Methods
extension CalendarViewController: UITableViewDelegate {
    // セルが選択されていることを通知する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したセルに指定した識別子でセグエを開始する
        performSegue(withIdentifier: K.listCell, sender: self)
        // セルをタッチした時に選択解除のアニメーションを追加
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // セグエ実行中の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 遷移先がArticleViewControllerなら選択しているDiaruListデータをselectedDiaryListsに渡す
        if let vc = segue.destination as? ArticleViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedDiaryLists = (diaryLists?.sorted(byKeyPath: "cellIndicateDate", ascending: false).filter("day == %@", day)[indexPath.row])!
//                    diaryLists.sorted(byKeyPath: "cellIndicateDate", ascending: false).filter("date == %@", sectionNames[indexPath.section])[indexPath.row]
            }
        }
    }
}
