//
//  ViewController.swift
//  Contacts
//
//  Created by Rajul Arora on 2015-09-19.
//  Copyright © 2015 Rajul Arora. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    LocationManagerDelegate,
    ContactManagerDelegate
{
    struct Constants {
        static let rowHeight: CGFloat = 54.0
        static let cellIdentifier = "cell"
    }

    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.rowHeight = Constants.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        tableView.registerClass(AvatarTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        return tableView
    }()

    private var mapViewController = BackgroundMapViewController()
    
    var userArray = NSMutableArray()
    var userID: String?
}

// MARK: - UIViewController

extension ViewController {
    override func loadView() {
        super.loadView()
        self.addChildViewController(self.mapViewController)
        self.view.addSubview(self.mapViewController.view)
        self.mapViewController.didMoveToParentViewController(self)
        self.mapViewController.view.frame = self.view.bounds

        self.view.addSubview(self.tableView)
        self.navigationItem.title = "Kontact"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.alpha = 0.7
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barStyle = .Black

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "user")?.imageWithRenderingMode(.AlwaysTemplate),
            style: .Plain,
            target: self,
            action: "profileButtonTapped:"
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if !ContactManager.manager.contactDoesExist() {
            let contactsViewController = ContactCardViewController()
            let navigationController = UINavigationController(rootViewController: contactsViewController)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.userID = userDefaults.stringForKey(kUserIDKey)
        
        LocationManager.manager.requestAccess()
        LocationManager.manager.delegate = self;
        
        ContactManager.manager.delegate = self;
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = CGRect(
            x: 0.0,
            y: self.topLayoutGuide.length,
            width: self.view.bounds.width,
            height: self.view.bounds.height - self.topLayoutGuide.length
        )
    }
}

// MARK: - UITableViewDelegate

extension ViewController {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! AvatarTableViewCell
        cell.textLabel?.text = (userArray.objectAtIndex(indexPath.row) as? User)?.firstName
        cell.contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let image = (self.userArray[indexPath.row] as? User)?.image, cell = cell as? AvatarTableViewCell {
            cell.avatarView.image = image
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
}

// MARK: - LocationManagerDelegate
extension ViewController {
    func locationManagerUserEnteredRadius(key: String) {
        if (self.userID == key) { return; }
        NSLog("user entered: %@", key)
        ContactManager.manager.userWithKey(key)
        
    }
    
    func locationManagerUserExitedRadius(key: String) {
        if (self.userID == key) { return; }
        NSLog("user exited: %@", key)
        
        var index = 0
        var found = false
        
        for user in self.userArray {
            if user.key == key {
                found = true
                break;
            }
            
            index++
        }
        
        if found {
            self.userArray.removeObjectAtIndex(index)
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
        }
        
    }
}

// MARK: - ContactManagerDelegate
extension ViewController {
    func contactManagerDidUpdateWithUser(user: User) {
        let newArray = userArray.filter { $0.key == user.key }
        
        if newArray.count == 0 {
            userArray.addObject(user)
            tableView.reloadData()
        }
    }
}

// MARK: - Events

extension ViewController {
    func profileButtonTapped(sender: AnyObject?) {
        let viewController = ContactCardViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}