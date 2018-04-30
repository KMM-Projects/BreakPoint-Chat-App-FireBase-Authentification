//
//  DataService.swift
//  breakpoint
//
//  Created by Caleb Stultz on 7/22/17.
//  Copyright © 2017 Caleb Stultz. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            // send to groups ref
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            
            handler(messageArray)
        }
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping(_ emailArray: [String]) -> ()){
        var emailArray = [String]()
        //we age gona observ all users and return what match our query
        
        REF_USERS.observe(.value) { (userSnapShot) in  //we are looking into entire reference and all his children
            guard let usersnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return}
            
            for user in usersnapShot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    // i shoul have not be apeared in the search = i am not allowed to find my self
                    emailArray.append(email)
                }
            }
            handler(emailArray)
            
        }
    }
    // we need a function wich can generate userID from his Email
    
    func getIds(forUsername usernames: [String], handler: @escaping(_ uidArray: [String])->()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            //assumin we get a value
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
        
    }
    //func to create a group
    
    func createGroup(withTitle title:String, andDescription description: String, forUserIds ids: [String], handler: @escaping(_ groupCreated: Bool)->()){
        //use groups reference if it is not there than it will create
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true) //succesfully created
        
    }
}
















