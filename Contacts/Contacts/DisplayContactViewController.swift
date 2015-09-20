//
//  DisplayContactViewController.swift
//  Contacts
//
//  Created by Zayaan Khatib on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

import Contacts

struct Constants {
    static let imageViewSize = CGSize(width: 150.0, height: 150.0)
    static let imageViewOffset: CGFloat = 25.0
    static let labelOffset: CGFloat = 20.0
}

class DisplayContactViewController:UIViewController {
    
    private var user: User

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.layer.cornerRadius = Constants.imageViewSize.width / 2.0
        imageView.userInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        return nameLabel
    }()
    
    private lazy var phoneLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        return nameLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        return nameLabel
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.nameLabel.text = "\(user.firstName) \(user.lastName)"
        self.emailLabel.text = user.email
        self.phoneLabel.text = user.phoneNumber
        self.imageView.image = user.image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DisplayContactViewController {
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.phoneLabel)
        self.scrollView.addSubview(self.emailLabel)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Contact", style: .Done, target: self, action: "didTapAddContact:")
        
    }
    
    override func viewWillLayoutSubviews() {
        self.scrollView.frame = self.view.bounds
        
        self.imageView.frame = CGRect(
            origin: CGPoint(
                x: (self.view.frame.width - Constants.imageViewSize.width) / 2.0,
                y: Constants.imageViewOffset
            ),
            size: Constants.imageViewSize
        )
        
        let nameSize = self.nameLabel.sizeThatFits(CGSize(width: self.view.frame.size.width, height: CGFloat.max))
        self.nameLabel.frame = CGRect(
            x: 20.0,
            y: self.imageView.frame.origin.y + Constants.imageViewSize.height + Constants.labelOffset,
            width: self.view.frame.width - 40.0,
            height: nameSize.height
        )
        
        let emailSize = self.emailLabel.sizeThatFits(CGSize(width: self.view.frame.size.width, height: CGFloat.max))
        self.emailLabel.frame = CGRect(
            x: 20.0,
            y: self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + Constants.labelOffset,
            width: self.view.frame.width - 40.0,
            height: emailSize.height
        )
        
        let phoneSize = self.phoneLabel.sizeThatFits(CGSize(width: self.view.frame.size.width, height: CGFloat.max))
        self.phoneLabel.frame = CGRect(
            x: 20.0,
            y: self.emailLabel.frame.origin.y + self.emailLabel.frame.size.height + Constants.labelOffset,
            width: self.view.frame.width - 40.0,
            height: phoneSize.height
        )
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.phoneLabel.frame.origin.y + phoneSize.height)
    }
}

extension DisplayContactViewController {
    func didTapAddContact(sender: AnyObject?)
    {
        let contact = CNMutableContact()
        
        contact.givenName = self.user.firstName
        contact.familyName = self.user.lastName
        
        if let image = self.user.image {
            contact.imageData = UIImagePNGRepresentation(image)
        }
        
        let homeEmail = CNLabeledValue(label:CNLabelHome, value:self.user.email)
        
        contact.emailAddresses = [homeEmail]
        
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:self.user.phoneNumber))]
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.addContact(contact, toContainerWithIdentifier:nil)
        
        do {
            try store.executeSaveRequest(saveRequest)
        } catch _ {}
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
