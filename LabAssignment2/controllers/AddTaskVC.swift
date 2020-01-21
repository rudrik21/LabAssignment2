//
//  AddTaskVC.swift
//  LabAssignment2
//
//  Created by Rudrik Panchal on 2020-01-20.
//  Copyright © 2020 Rudrik Panchal. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {

    //  MARK: outlets
    @IBOutlet weak var edtTitle: UITextField!
    @IBOutlet weak var edtDesc: UITextField!
    @IBOutlet weak var dtPicker: UIDatePicker!
    
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var sliderDays: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dtPicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())

    }
    
    @IBAction func onSliderChange(_ sender: UISlider) {
        lblDays.text = String(Int(sender.value))
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("onUnwind")
        let task = Task(title: edtTitle.text, desc: edtDesc.text, dt: dateFormatter?.string(from: dtPicker.date), cDays: 0, totalDays: Int(lblDays.text ?? "1")!)
        
        print(task.toString())
        
        print(addNewTaskData(tasks: [task]))
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
