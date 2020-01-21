//
//  TaskCell.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    //  MARK: outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTask(task: Task) {
        let count = (Int(task.totalDays!)) - (Int(task.cDays!))
        lblTitle.text = task.title
        lblDesc.text = task.desc
        lblDays.text = String(count)
        self.lblDate.text = dateToString(task.dt!)
        if count == 0{
            self.backgroundColor = .brown
        }else{
            self.backgroundColor = .white
        }
    }
}
