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
    UITableViewDataSource
{
    struct Constants {
        static let rowHeight: CGFloat = 44.0
        static let cellIdentifier = "cell"
    }

    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.rowHeight = Constants.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        return tableView
    }()
}

// MARK: - Geo

func geoQuery()
{
    let center = LocationManager.manager.myLoc
    let circleQuery = LocationManager.manager.geoFire.queryAtLocation(center, withRadius: 0.4)
    
    circleQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
        NSLog("%@, %@", key, location)
    })
}

// MARK: - UIViewController

extension ViewController {
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.tableView)
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
        LocationManager.manager.requestAccess()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
}

// MARK: - UITableViewDelegate

extension ViewController {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = "Something"
        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

// MARK: - UITableViewDataSource

extension ViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}