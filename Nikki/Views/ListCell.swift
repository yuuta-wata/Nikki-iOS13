//
//  ListCell.swift
//  Nikki
//
//  Created by 渡辺雄太 on 2019/12/30.
//  Copyright © 2019 Yuta Watanabe. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    
    @IBOutlet weak var listView: UIStackView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    // 変数名imageViewにするとUITableViewCellの予約語と被るので、省略する
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // コーナーを丸くする
        listView.layer.cornerRadius = listView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
