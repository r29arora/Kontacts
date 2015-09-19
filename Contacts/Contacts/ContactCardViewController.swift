//
//  ContactCardViewController.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

class ContactCardViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate
{
    struct Constants {
        static let imageViewSize = CGSize(width: 100.0, height: 100.0)
        static let imageViewOffset: CGFloat = 50.0
        static let textFieldHeight: CGFloat = 50.0
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.layer.cornerRadius = Constants.imageViewSize.width / 2.0
        imageView.userInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "didSelectImageView:")
        imageView.addGestureRecognizer(tapRecognizer)
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .Left
        textField.textColor = UIColor.blackColor()
        textField.placeholder = "First Name"
        textField.delegate = self
        return textField
    }()

    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .Left
        textField.placeholder = "Last Name"
        textField.delegate = self
        return textField
    }()

    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .PhonePad
        textField.placeholder = "Phone Number"
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .EmailAddress
        textField.placeholder = "Email"
        textField.delegate = self
        return textField
    }()

    var didSetImage: Bool = false

    init() {
        super.init(nibName: nil, bundle: nil)

        let manager = ContactManager.manager
        self.firstNameTextField.text = manager.firstName
        self.lastNameTextField.text = manager.lastName
        self.emailTextField.text = manager.email
        self.phoneNumberTextField.text = manager.phoneNumber
        self.imageView.image = manager.image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIViewController

extension ContactCardViewController {
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "didTapView:")
        self.view.addGestureRecognizer(tapRecognizer)

        if ContactManager.manager.contactDoesExist() {
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

        self.navigationItem.title = "My Contact Info"

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.firstNameTextField)
        self.scrollView.addSubview(self.lastNameTextField)
        self.scrollView.addSubview(self.emailTextField)
        self.scrollView.addSubview(self.phoneNumberTextField)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.scrollView.frame = self.view.bounds

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

        self.emailTextField.frame = CGRect(
            x: 20.0,
            y: self.lastNameTextField.frame.origin.y + Constants.textFieldHeight + 10.0,
            width: self.view.frame.width - 40.0,
            height: Constants.textFieldHeight
        )

        self.phoneNumberTextField.frame = CGRect(
            x: 20.0,
            y: self.emailTextField.frame.origin.y + Constants.textFieldHeight + 10.0,
            width: self.view.frame.width - 20.0,
            height: Constants.textFieldHeight
        )

        self.scrollView.contentSize = CGSize(
            width: self.view.frame.width,
            height: self.phoneNumberTextField.frame.height + self.phoneNumberTextField.frame.origin.y + self.topLayoutGuide.length
        )
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ContactCardViewController {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.didSetImage = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate 

extension ContactCardViewController {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}

// MARK: - NSNotificationCenter

extension ContactCardViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let
            info = notification.userInfo,
            keyboardInfo = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardFrame = keyboardInfo.CGRectValue()
            let insets = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        let insets = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
    }
}

// MARK: - Events

extension ContactCardViewController {
    func didSelectCancel(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func didSelectDone(sender: AnyObject?) {
        // Save contact Information
        if let image = self.imageView.image {
            if self.didSetImage {
                ContactManager.manager.saveImage(image)
            }
        }

        if let
            firstName = self.firstNameTextField.text,
            lastName = self.lastNameTextField.text,
            email = self.emailTextField.text,
            phoneNumber = self.phoneNumberTextField.text
        {
            ContactManager.manager.save(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
            ContactManager.manager.saveUserData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func didSelectImageView(sender: AnyObject?) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    func didTapView(sender: AnyObject?) {
        self.view.endEditing(true)
    }
}