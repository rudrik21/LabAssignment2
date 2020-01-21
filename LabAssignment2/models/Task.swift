//
//  Task.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import Foundation
import CoreData

class Task {
    internal init(title: String?, desc: String?, dt: String?, cDays: Int = 0, totalDays: Int = 0) {
        self.title = title
        self.dt = dt
        self.desc = desc
        self.cDays = cDays
        self.totalDays = totalDays
    }
    
    var title: String?
    var dt: String?
    var desc: String?
    var cDays: Int?
    var totalDays: Int?
    
    func toString() -> String {
        return "Title: \(title ?? ""), Desc: \(desc ?? ""), Date: \(dt ?? ""), cDays: \(cDays ?? -1), totalDays: \(totalDays ?? -1)"
    }
    
}
