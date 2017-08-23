//
//  ChatTableViewController.swift
//  benjamin
//
//  Created by Brandon on 2017-08-22.
//  Copyright © 2017 Elevate Digital. All rights reserved.
//

import Foundation
import UIKit

class ChatTableViewController: UITableViewController {
    
    struct Constants {
        static let cellReuseIdentifier = "ChatTableViewCell"
    }
    
    var messages: [String]
    
    
    init(messages: [String]) {
        self.messages = messages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       self.messages = []
        super.init(coder: aDecoder)
    }
    
    func insertMessage(message: String) {
        self.messages.append(message)
        tableView.insertRows(at: [IndexPath.init(row: messages.count - 1, section: 0)], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}