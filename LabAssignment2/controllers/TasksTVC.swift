//
//  TasksTVC.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import UIKit
import CoreData

var delegate: AppDelegate?
var context: NSManagedObjectContext?
var dateFormatter: DateFormatter?

class TasksTVC: UITableViewController, UISearchBarDelegate {

    //  MARK: variables
    
    var oldTasks: [Task] = []
    var tasks: [Task] = []
    
    //  MARK: outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = (UIApplication.shared.delegate as! AppDelegate)
        context = delegate?.persistentContainer.viewContext
        dateFormatter = DateFormatter()
        dateFormatter!.dateFormat = "MMM dd, YYYY"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        tasks = fetchTaskData()
        tasks.forEach { (t) in
            print("fetched data: ", t.toString())
        }
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = []
        tasks = fetchTaskData()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tasks = []
        tableView.reloadData()
        
        if !searchText.isEmpty {
             var tempTasks = fetchTaskData()
        
            tempTasks.forEach { (t) in
                if ((t.title?.contains(searchText)) != nil) || (((t.dt?.contains(searchText)) != nil)){
                        tempTasks.append(t)
                }
            }
            tasks = []
            tasks = tempTasks
            tableView.reloadData()
        }else{
            tasks = []
            tasks = fetchTaskData()
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskCell{

            let position = indexPath.row
            let task = tasks[position]
            cell.setTask(task: task)
            return cell
        }

        return UITableViewCell()
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            print("onDelete")
        } else if editingStyle == .insert {
            print("onAdd")
        }
    */
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pos = indexPath.row
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (act, v, nil) in
            act.backgroundColor = .red
            print("onDelete")
            self.tasks.remove(at: pos)
            
            //  update database
            clearTaskData()
            addNewTaskData(tasks: self.tasks)
            
            tableView.reloadData()
        }
        
        let increase = UIContextualAction(style: .normal, title: "Add a day") { (act, v, nil) in
            act.backgroundColor = .green
            print("onAddDay")
            let t = self.tasks[pos]
            t.cDays = t.cDays! + 1
            self.tasks[pos] = t
            
            //  update database
            clearTaskData()
            addNewTaskData(tasks: self.tasks)
            
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete, increase])
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
    }

}
