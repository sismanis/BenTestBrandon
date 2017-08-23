//
//  ChatStackViewController.swift
//  benjamin
//
//  Created by Brandon on 2017-08-22.
//  Copyright © 2017 Elevate Digital. All rights reserved.
//

import Foundation
import UIKit

class ChatStackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Constants {
        static let cellReuseIdentifier = "ChatTableViewCell"
    }
    
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textInputView: UIView!
    
    var messages: [String]
    
    required init?(coder aDecoder: NSCoder) {
        self.messages = ["Teach me about Bitcoin"]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        chatTableView.dataSource = self
        chatTableView.delegate = self
    }
    
    // MARK: UITableViewDataSource delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
}
