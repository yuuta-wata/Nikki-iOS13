//
//  CalenderViewController.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/27.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

protocol ViewLogic {
    var numberOfWeeks: Int { get set }
    var daysArray: [String] { get set }
}

class CalendarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarNavigationItem: UINavigationItem!
    @IBOutlet weak var prevBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
