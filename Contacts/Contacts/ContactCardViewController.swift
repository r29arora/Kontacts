//
//  ContactCardViewController.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class ContactCardViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    struct Constants {
        static let imageViewSize = CGSize(width: 100.0, height: 100.0)
        static let imageViewOffset: CGFloat = 100.0
        static let textFieldHeight: CGFloat = 60.0
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blueColor()
        imageView.layer.cornerRadius = Constants.imageViewSize.width / 2.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.userInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()

    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .Left
        textField.textColor = UIColor.blackColor()
        textField.placeholder = "First Nme"
        return textField
    }()

    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .Left
        textField.placeholder = "Last Name"
        return textField
    }()

    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .PhonePad
        textField.placeholder = "Phone Number"
        return textField
    }()
}

// MARK: - UIViewController

extension ContactCardViewController {
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()

        if !ContactManager.manager.contactDoesExist() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "didSelectCancel:"
            )
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: "didSelectDone:"
        )

        self.view.addSubview(self.imageView)
        self.view.addSubview(self.firstNameTextField)
        self.view.addSubview(self.lastNameTextField)
        self.view.addSubview(self.phoneNumberTextField)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "didSelectImageView:")
        self.imageView.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imageView.frame = CGRect(
            origin: CGPoint(
                x: (self.view.frame.width - Constants.imageViewSize.width) / 2.0,
                y: Constants.imageViewOffset
            ),
            size: Constants.imageViewSize
        )

        self.firstNameTextField.frame = CGRect(
            x: 20.0,
            y: self.imageView.frame.origin.y + Constants.imageViewSize.height + 20.0,
            width: self.view.frame.width - 40.0,
            height: Constants.textFieldHeight
        )

        self.lastNameTextField.frame = CGRect(
            x: 20.0,
            y: self.firstNameTextField.frame.origin.y + Constants.textFieldHeight + 10.0,
            width: self.view.frame.width - 40.0,
            height: Constants.textFieldHeight
        )

        self.phoneNumberTextField.frame = CGRect(
            x: 20.0,
            y: self.lastNameTextField.frame.origin.y + Constants.textFieldHeight + 10.0,
            width: self.view.frame.width - 20.0,
            height: Constants.textFieldHeight
        )
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ContactCardViewController {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Events 

extension ContactCardViewController {
    func didSelectCancel(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func didSelectDone(sender: AnyObject?) {
        // Save contact Information
    }

    func didSelectImageView(sender: AnyObject?) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
}