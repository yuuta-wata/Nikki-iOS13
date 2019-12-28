//
//  CalendarPresenter.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/27.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import Foundation

protocol ResponseForCalendar {
    func responseDateManager(response: [String])
    func responseNumberOfWeeks(resopnse: Int)
}

class CalendarPresenter: ResponseForCalendar {
    
    var viewLogic: ViewLogic?
    
    func responseDateManager(response: [String]) {
        viewLogic?.daysArray = response
    }
    func responseNumberOfWeeks(resopnse: Int) {
        viewLogic?.numberOfWeeks = resopnse
    }
}
