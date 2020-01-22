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
    var isAsc = true
    var selectedTask : Task?
    var isNewTask: Bool = true
    
    //  MARK: outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = (UIApplication.shared.delegate as! AppDelegate)
        context = delegate?.persistentContainer.viewContext
        dateFormatter = DateFormatter()
        dateFormatter!.dateFormat = "MMM dd, YYYY"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resetFocus))
        navigationController?.navigationBar.addGestureRecognizer(tap)
        searchBar.delegate = self
       
    }
    
    @objc func resetFocus() {
           searchBar.resignFirstResponder()
       }
    
    //  MARK: sort by title
    @IBAction func onSortByTitle(_ sender: UIBarButtonItem) {
        isAsc.toggle()
        tasks = fetchTaskData(isDate: false, isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: sort by date
    @IBAction func onSortByDate(_ sender: UIBarButtonItem) {
        isAsc.toggle()
        tasks = fetchTaskData(isDate: true, isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: view will appear
    override func viewWillAppear(_ animated: Bool) {
        isNewTask = true
        tasks = []
        searchBar.text = ""
        tasks = fetchTaskData(isAsc: isAsc)
        tableView.reloadData()
    }
    
    //  MARK: on search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tasks = []
        if !searchText.isEmpty {
            tasks = fetchTaskData(search: searchText, isAsc: isAsc)
            tableView.reloadData()
        }else{
            tasks = fetchTaskData(isAsc: isAsc)
        }
        tableView.reloadData()
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
            cell.setTask(task: task, searchText: searchBar.searchTextField.text!)
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
        let t = self.tasks[pos]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (act, v, nil) in
            act.backgroundColor = .red
            print("onDelete")
            self.tasks.remove(at: pos)
            
            //  update database
            deleteTaskData(tasks: [t])
            
            tableView.reloadData()
        }
        
        let increase = UIContextualAction(style: .normal, title: "Add a day") { (act, v, nil) in
            act.backgroundColor = .green
            print("onAddDay")
            t.cDays = t.cDays! + 1
            
            if t.cDays! <= t.totalDays!{
            
                self.tasks[pos] = t
                
                //  update database
                deleteTaskData(tasks: [t])
               
                addNewTaskData(tasks: [t])
                tableView.reloadData()
            }
        }
        
        var acts : UISwipeActionsConfiguration?
        if t.cDays!  >= t.totalDays! {
            acts = UISwipeActionsConfiguration(actions: [delete])
        }else{
            acts = UISwipeActionsConfiguration(actions: [delete, increase])
        }
        return acts
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("inside prepare")
        if let addTaskVC = segue.destination as? AddTaskVC {
            if let cell = sender as? TaskCell{
                addTaskVC.tasksTVC = self
                let pos = tableView.indexPath(for: cell)?.row
                selectedTask = tasks[pos!]
                print("selected cell", selectedTask?.toString())
            }
            
        }
    }
    
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
    }

    
}
