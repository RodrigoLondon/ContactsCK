//
//  ContactController.swift
//  ContactsCKAssessment
//
//  Created by Cody on 9/28/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit

class ContactController{
    
    static let shared = ContactController()
    private init(){}
    
    var contacts: [Contact] = []{
        didSet{
            NotificationCenter.default.post(name: contactsWereUpdatedNotification, object: nil)
        }
    }
    var contact: Contact?
    
    let contactsWereUpdatedNotification = Notification.Name("ContactsWereUpdated")

        //create and save
    func createContact(name: String, phoneNumber: String, email: String, completion: ((Contact?) -> Void)?){
        let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        self.contacts.append(contact)
        
        CKContainer.default().publicCloudDatabase.save(CKRecord(contact: contact)) { (record, error) in
            if let error = error{
                print("🤬 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 🤬")
                completion?(nil)
                return
            }
//            guard let record = record else {return}
//            let contact = Contact(ckRecord: record)
            self.contact = contact
            completion?(contact)
        }
    }
    //Fetch
    func fetchContacts(completion: @escaping ([Contact]?) -> Void){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.ContactRecordType, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("🤬 There was an error in \(#function) ; \(error) ; \(error.localizedDescription) 🤬")
                completion(nil)
                return
            }
            guard let records = records else {return}
            let contacts: [Contact] = records.compactMap{Contact(ckRecord: $0)}
            self.contacts = contacts
            completion(contacts)
        }
    }
    //Update
    func updateContact(contact: Contact, name: String, phoneNumber: String, email: String, completion: ((Bool) -> Void)?){
        //update local
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.email = email
        
        //update cloud
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: contact.ckRecordID) { (record, error) in
            if let error = error{
                print("🤬 There was an error fetching in \(#function) ; \(error) ; \(error.localizedDescription) 🤬")
                completion?(false)
                return
            }
            //if there is a problem, look at record here
            guard let record = record else {return}
            record[Constants.NameKey] = name
            record[Constants.PhoneNumberKey] = phoneNumber
            record[Constants.EmailKey] = email
            let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            operation.savePolicy = .changedKeys
            operation.queuePriority = .high
            operation.qualityOfService = .userInitiated
            operation.modifyRecordsCompletionBlock = {(records, recordIDS, error) in
                completion?(true)
            }
            CKContainer.default().publicCloudDatabase.add(operation)
        }
    }
    
    
}
