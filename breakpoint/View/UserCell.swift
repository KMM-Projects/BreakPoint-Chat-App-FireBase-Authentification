//
//  UserCell.swift
//  breakpoint
//
//  Created by Patrik Kemeny on 29/4/18.
//  Copyright © 2018 Caleb Stultz. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool){
        self.profileImage.image = image
        self.emailLabel.text = email
        
        if isSelected  {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
    }
    
// to toggled the checkMark
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
        if showing == false {
            checkImage.isHidden = false
            showing = true
        } else {
            checkImage.isHidden = true
            showing = false
        }
      }
    }

}
