//
//  helper.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import Foundation
import CoreData

func addNewTaskData(tasks: [Task]) -> Bool {
    var res = false
    tasks.forEach { (t) in
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "TaskData", into: context!)
        newTask.setValue(t.title, forKey: "title")
        newTask.setValue(t.desc, forKey: "desc")
        newTask.setValue(t.dt, forKey: "dt")
        newTask.setValue(t.cDays, forKey: "c_days")
        newTask.setValue(t.totalDays, forKey: "total_days")
        
        do {
            try context!.save()
            print("new task is \(newTask)")
            res = true
        } catch {
            print(error)
        }
    }
    return res
}

func fetchTaskData(search: String = "", isDate: Bool = false, isAsc: Bool = true, isSame: Bool = false) -> [Task] {
    var tempTasks = [Task]()
    
    let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskData")
    if !isDate {
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: isAsc)]
    }else{
        req.sortDescriptors = [NSSortDescriptor(key: "dt", ascending: isAsc)]
    }
    
    if !search.isEmpty {
        if !isSame{
            let p1 = NSPredicate(format: "ANY title CONTAINS[c] %@", "\(search)")
            let p2 = NSPredicate(format: "ANY desc CONTAINS[c] %@", "\(search)")
            req.predicate = NSCompoundPredicate(type: .or, subpredicates: [p1, p2])
        }else{
            req.predicate = NSPredicate(format: "title = %@", "\(search)")
        }
        
        req.returnsObjectsAsFaults = false
    }
    
    do {
        let res = try context?.fetch(req)
        if !res!.isEmpty{
            (res as! [NSManagedObject]).forEach({ u in
                let t = Task(
                    title: u.value(forKey: "title") as? String
                    , desc: u.value(forKey: "desc") as? String,
                      dt: u.value(forKey: "dt") as? Date,
                      cDays: u.value(forKey: "c_days") as! Int,
                      totalDays: u.value(forKey: "total_days") as! Int)
                tempTasks.append(t)
            })
        }
    } catch {
        print(error)
    }
    
    return tempTasks
}

func deleteTaskData(tasks: [Task]) {
    tasks.forEach { (task) in
    
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskData")
        req.predicate = NSPredicate(format: "title = %@ ", task.title!)
        
        let delReq = NSBatchDeleteRequest(fetchRequest: req)
        do {
            try context!.execute(delReq)
        }
        catch { print(error) }
       
        
    }
}

func clearTaskData() {
    let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskData")
    let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
    do { try context!.execute(DelAllReqVar) }
    catch { print(error) }
}

func dateToString(_ dt: Date) -> String {
    if dt != nil{
        return dateFormatter?.string(from: dt) ?? ""
    }
    return ""
}
