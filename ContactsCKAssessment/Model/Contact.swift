//
//  Contact.swift
//  ContactsCKAssessment
//
//  Created by Cody on 9/28/18.
//  Copyright © 2018 Cody Adcock. All rights reserved.
//

import Foundation
import CloudKit

class Contact{
    var name: String
    var phoneNumber: String
    var email: String
    let ckRecordID:CKRecord.ID
    
    init(name: String, phoneNumber: String, email: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.ckRecordID = ckRecordID
    }
    
    //failable initializer
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord[Constants.NameKey] as? String,
            let phoneNumber = ckRecord[Constants.PhoneNumberKey] as? String,
            let email = ckRecord[Constants.EmailKey] as? String else {return nil}
        
        //designated Initializer
        self.init(name: name, phoneNumber: phoneNumber, email: email, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord{
    convenience init(contact: Contact){
        self.init(recordType: Constants.ContactRecordType, recordID: contact.ckRecordID)
        self.setValue(contact.name, forKey: Constants.NameKey)
        self.setValue(contact.phoneNumber, forKey: Constants.PhoneNumberKey)
        self.setValue(contact.email, forKey: Constants.EmailKey)
    }
}

struct Constants{
    static let ContactRecordType = "Contact"
    static let NameKey = "Name"
    static let PhoneNumberKey = "PhoneNumber"
    static let EmailKey = "Email"
}
