//
//  ContactManager.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class ContactManager: NSObject {
    struct Constants {
        static let contactInfoDictionaryKey = "contactsDictionary"
    }

    static let manager = ContactManager()

    var firstName: String = ""
    var lastName: String = ""
    var email: [String] = []
    var phoneNumber: [String] = []


    override init() {
        super.init()

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let contactInfo = userDefaults.objectForKey("contactsDictionary") as? NSDictionary {
            self.firstName = contactInfo["firstName"] as? String ?? ""
            self.lastName = contactInfo["lastName"] as? String ?? ""
            self.email = contactInfo["email"] as? [String] ?? []
            self.phoneNumber = contactInfo["phoneNumber"] as? [String] ?? []
        }
    }
}

// MARK: - Public Methods

extension ContactManager {
    func contactDoesExist() -> Bool {
        if self.firstName == "" && self.lastName == "" {
            return false
        }

        return true
    }
}
