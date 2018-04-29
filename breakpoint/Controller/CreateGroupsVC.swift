//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Patrik Kemeny on 29/4/18.
//  Copyright © 2018 Caleb Stultz. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var groupMemberLabel: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    
    }

    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
    }
}
