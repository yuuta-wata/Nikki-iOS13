//
//  CalendarViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/29.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CalendarViewController: FSCalendarDataSource {
    private func formatter() {
        let jpCalendar = Calendar(identifier: .gregorian)
        let date = jpCalendar.dateComponents([.year, .month ], from: Date())
        
    }
}
