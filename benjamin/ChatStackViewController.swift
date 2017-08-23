//
//  ChatStackViewController.swift
//  benjamin
//
//  Created by Brandon on 2017-08-22.
//  Copyright © 2017 Elevate Digital. All rights reserved.
//

import Foundation
import UIKit

class ChatStackViewController: UIViewController, UITextViewDelegate {
    
    struct Constants {
        static let placeholderText = "Type a message..."
        static let leaderboardViewMinimumHeight: CGFloat = 40.0
        static let leaderboardViewPreviewHeight: CGFloat = 150.0
    }
    
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leaderboardViewHeightConstraint: NSLayoutConstraint!
    
    let chatTableViewController: ChatTableViewController
    
    required init?(coder aDecoder: NSCoder) {
        chatTableViewController = ChatTableViewController(messages: ["Teach me about Bitcoin"])
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
        chatTableView.separatorStyle = .none
        chatTableViewController.tableView = chatTableView
        textView.delegate = self
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        chatTableViewController.insertMessage(message: textView.text)
        textView.text = ""
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
            leaderboardViewHeightConstraint.constant = Constants.leaderboardViewPreviewHeight
        } else {
            bottomConstraint.constant = endFrame.size.height
            leaderboardViewHeightConstraint.constant = Constants.leaderboardViewMinimumHeight
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: animationCurve, animations: { self.view.layoutIfNeeded() }, completion: nil)
    }
}
