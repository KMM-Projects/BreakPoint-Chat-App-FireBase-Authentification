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
    
    var emailArray = [String]()
    
    @IBOutlet weak var groupMemberLabel: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self //give us the ability to interact with the textfield
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged) //monitor all event conected with the TextField


    }

    @objc func textFieldDidChange(){
        if emailSearchTextField.text == "" {
            //if emptu search just reload the tableview
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })
            
        }
        
    }
    
    
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell  else {
            return UITableViewCell() }
       let profileImage = UIImage(named: "defaultProfileImage")
        
        cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        return cell
    }
    
}
// when i start to search for email and i press "c" the search query should be everything what started with C than if i type "ce" everything what start with CE should be in query = i am updating the query to achieve this i need this extension

extension CreateGroupsVC: UITextFieldDelegate {
    
    
}







