//
//  AddTaskVC.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {

    var tasksTVC: TasksTVC?
    
    
    //  MARK: outlets
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    
    @IBOutlet weak var edtTitle: UITextField!
    @IBOutlet weak var edtDesc: UITextField!
    @IBOutlet weak var dtPicker: UIDatePicker!
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var sliderDays: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(resetFocus))
        view.addGestureRecognizer(tap)
        
        dtPicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        if let tasksTVC = tasksTVC{
            btnAdd.title = "Update"
            let task = tasksTVC.selectedTask
            edtTitle.text = task?.title
            edtDesc.text = task?.desc
            dtPicker.date = task!.dt!
            lblDays.text = String(task!.totalDays!)
            sliderDays.value = Float(task!.totalDays!)
        }
    }
    
    @objc func resetFocus() {
        edtTitle.resignFirstResponder()
        edtDesc.resignFirstResponder()
    }
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        lblDays.text = String(Int(sender.value))
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
       
        print("onUnwind")
        let task = Task(title: edtTitle.text, desc: edtDesc.text, dt: dtPicker.date, cDays: 0, totalDays: Int(lblDays.text ?? "1")!)
        
        print(task.toString())
        
        if let tasksTVC = tasksTVC{
            deleteTaskData(tasks: [tasksTVC.selectedTask!])
            
            tasksTVC.selectedTask = nil
            tasksTVC.isNewTask = true
            
        }
        
        print("New task added? -> ", addNewTaskData(tasks: [task]))
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (edtTitle.text!.isEmpty) || (edtDesc.text!.isEmpty) {
            
            let alert = UIAlertController(title: "Empty field!", message: "Please enter data to save...", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
            return false
        }
        if(!edtTitle.text!.isEmpty && tasksTVC == nil && !fetchTaskData(search: edtTitle.text!, isSame: true).isEmpty) {
        let alert = UIAlertController(title: "Same title!", message: "Can't have same titles", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (act) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
