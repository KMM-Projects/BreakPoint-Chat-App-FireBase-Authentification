//
//  CreateGroupsVC.swift
//  breakpoint
//
//  Created by Patrik Kemeny on 29/4/18.
//  Copyright © 2018 Caleb Stultz. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    @IBOutlet weak var groupMemberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self //give us the ability to interact with the textfield
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged) //monitor all event conected with the TextField


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
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
        //create a group
        if titleTextField.text != "" && description != "" {
            //download all usersID from email
            DataService.instance.getIds(forUsername: chosenUserArray, handler: { (idsArray) in
                //add my self to this erray
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("group cant be created")
                    }
                })
            })
        }
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
        if chosenUserArray.contains(emailArray[indexPath.row]) {
        cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
        cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
    }
        return cell } 
    //when you select a tableView cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //create a cell and pul the email from the cell
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return} // give as an actual cell 
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!) //add to the end of the array the new email
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! }) // filter we want to kepp everybody who is not the current cell
            if chosenUserArray.count >= 1 {
                groupMemberLabel.text = chosenUserArray.joined(separator: "; ")
            } else {
                groupMemberLabel.text = "Add People To your Group"
                doneBtn.isHidden = true
            }
        }
    }
    
    
}
// when i start to search for email and i press "c" the search query should be everything what started with C than if i type "ce" everything what start with CE should be in query = i am updating the query to achieve this i need this extension

extension CreateGroupsVC: UITextFieldDelegate {
    
    
}







