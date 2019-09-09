//
//  ContactDetailViewController.swift
//  ContactsCKAssessment
//
//  Created by Cody on 9/28/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //landing pad
    var contact: Contact?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func updateViews(){
        guard let contact = contact else {return}
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let nameText = nameTextField.text else {return}
        if let contact = contact{
            ContactController.shared.updateContact(contact: contact, name: nameText, phoneNumber: phoneNumberTextField.text ?? "", email: emailTextField.text ?? "") { (success) in
                if success{
                    print("Success Updating 🤤")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    print("Failed to Update 🤮")
                }
            }
        }else{
            ContactController.shared.createContact(name: nameText, phoneNumber: phoneNumberTextField.text ?? "", email: emailTextField.text ?? "") { (_) in
                
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
