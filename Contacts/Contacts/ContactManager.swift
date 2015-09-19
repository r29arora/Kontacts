//
//  ContactManager.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class User: NSObject {
    var key: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var image: UIImage?
    
    init(key:String,
        firstName:String,
        lastName:String,
        email:String,
        phoneNumber:String,
        image:UIImage?) {
        
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        
        super.init()
    }
}

@objc protocol ContactManagerDelegate {
    func contactManagerDidUpdateWithUser(user: User)
}

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
    
    weak var delegate:ContactManagerDelegate?

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
    
    func userWithKey(key: String)
    {
        self.userBaseRef.childByAppendingPath(key).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let
                contactInfo = snapshot.value as? NSDictionary,
                firstName = contactInfo["firstName"] as? String,
                lastName = contactInfo["lastName"] as? String,
                email = contactInfo["email"] as? String,
                phoneNumber = contactInfo["phoneNumber"] as? String
            {

                let user = User(
                    key: key,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    phoneNumber: phoneNumber,
                    image: nil
                )
                
                if let
                    imageString = contactInfo["image"] as? String,
                    imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                {
                    user.image = UIImage(data: imageData)
                }
                
                self.delegate?.contactManagerDidUpdateWithUser(user)
            }
        }) { (error) -> Void in
            NSLog("error - %@", error.description)
        }
    }
}