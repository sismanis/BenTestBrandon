//
//  ChatStackViewController.swift
//  benjamin
//
//  Created by Brandon on 2017-08-22.
//  Copyright © 2017 Elevate Digital. All rights reserved.
//

import Foundation
import UIKit

class ChatStackViewController: UIViewController, UITableViewDataSource, UITextViewDelegate {
    
    struct Constants {
        static let cellReuseIdentifier = "ChatTableViewCell"
        static let placeholderText = "Type a message..."
        
    }
    
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var messages: [String]
    
    required init?(coder aDecoder: NSCoder) {
        self.messages = ["Teach me about Bitcoin"]
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        textView.textColor = UIColor.lightGray
        textView.text = Constants.placeholderText
        sendButton.isEnabled = false
        sendButton.setTitleColor(.lightGray, for: .disabled)
        chatTableView.dataSource = self
        textView.delegate = self
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
    // MARK: NSNotification
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        let animationCurve = UIViewAnimationOptions.curveEaseInOut
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            bottomConstraint.constant = 0.0
        } else {
            bottomConstraint.constant = endFrame.size.height
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
}
