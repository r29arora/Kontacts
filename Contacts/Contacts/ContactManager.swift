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
        static let contactImageKey = "contactImage"
    }

    static let manager = ContactManager()

    let userBaseRef: Firebase
    let fireBaseRef:Firebase
    var userID: String?

    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var image: UIImage?


    override init() {
        self.fireBaseRef = Firebase(url: fireBaseUrl)
        self.userBaseRef = self.fireBaseRef.childByAppendingPath("user")

        super.init()

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let contactInfo = userDefaults.objectForKey(Constants.contactInfoDictionaryKey) as? NSDictionary {
            self.firstName = contactInfo["firstName"] as? String ?? ""
            self.lastName = contactInfo["lastName"] as? String ?? ""
            self.email = contactInfo["email"] as? String ?? ""
            self.phoneNumber = contactInfo["phoneNumber"] as? String ?? ""
        }

        if let encodedImage = NSUserDefaults.standardUserDefaults().objectForKey(Constants.contactImageKey) as? NSData {
            self.image = UIImage(data: encodedImage)
        }
    }
}

// MARK: - Public Methods

extension ContactManager {
    func contactDoesExist() -> Bool {
        if self.firstName == "" && self.lastName == "" && self.email == "" && self.phoneNumber == "" {
            return false
        }

        return true
    }

    func save(firstName firstName: String, lastName: String, email: String, phoneNumber: String) {
        let contactDictionary = [
            "firstName": firstName,
            "lastName" : lastName,
            "email" : email,
            "phoneNumber": phoneNumber
        ]
        
        NSUserDefaults.standardUserDefaults().setObject(contactDictionary, forKey: Constants.contactInfoDictionaryKey)

        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }

    func saveImage(image: UIImage) {
        if let imageData = UIImageJPEGRepresentation(image, 0.1) {
            NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: Constants.contactImageKey)
        }

        self.image = image
    }
    
    func removeUserData() {
        self.userBaseRef.childByAppendingPath(self.userID).removeValue()
    }

    func saveUserData() {
        self.userID = NSUserDefaults.standardUserDefaults().stringForKey(kUserIDKey)
        if let contactInfo = NSUserDefaults.standardUserDefaults().objectForKey(Constants.contactInfoDictionaryKey) as? NSDictionary {
            self.userBaseRef.childByAppendingPath(self.userID).setValue(contactInfo)
        }

        if let
            image = self.image,
            imageData = UIImageJPEGRepresentation(image, 0.1)
        {
            let imageString = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            self.userBaseRef.childByAppendingPath(self.userID).updateChildValues(["image": imageString])
        }
    }
}
