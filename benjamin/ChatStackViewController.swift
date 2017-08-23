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
        static let leaderboardViewMinimumHeight: CGFloat = 60.0
        static let leaderboardViewPreviewHeight: CGFloat = 150.0
        static let inputViewBorderWidth = 1
        static let pullTabViewCornerRadius: CGFloat = 20.0
        static let pullTabPanThreshold: CGFloat = 50.0
        static let panAnimationInterval = TimeInterval(0.25)
    }
    
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatInputView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var pullTabView: UIView!
    
    @IBOutlet var pullTabGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var leaderboardViewHeightConstraint: NSLayoutConstraint!
    
    let chatTableViewController: ChatTableViewController
    var chatViewIsHidden = false
    
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
        
        textView.textColor = .lightGray
        textView.text = Constants.placeholderText
        textView.delegate = self
        textView.resignFirstResponder()
        
        sendButton.isEnabled = false
        sendButton.setTitleColor(.lightGray, for: .disabled)
        
        chatTableView.separatorStyle = .none
        chatTableViewController.tableView = chatTableView
        
        let inputViewBorder = UIView(frame: CGRect(x: 0, y: 0, width: Int(chatInputView.frame.width), height: Constants.inputViewBorderWidth))
        inputViewBorder.backgroundColor = .lightGray
        inputViewBorder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        chatInputView.addSubview(inputViewBorder)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pullTabView.roundCorners(corners: [.topLeft, .topRight], radius: Constants.pullTabViewCornerRadius)
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
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: animationCurve,
                       animations: { [weak self] in
                            self?.view.layoutIfNeeded()
                        },
                       completion: nil)
    }
    
    // MARK: pullTabGestureRecognizer
    
    func configurePullTabGestureRecognizer() {
        pullTabGestureRecognizer.minimumNumberOfTouches = 1
        pullTabGestureRecognizer.maximumNumberOfTouches = 1
    }
    
    @IBAction func pullTabPanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let pullTabView = gestureRecognizer.view?.superview
        let yTranslation = gestureRecognizer.translation(in: pullTabView).y
        let chatViewHideThreshold = Constants.leaderboardViewPreviewHeight + Constants.pullTabPanThreshold
        let chatViewExpandThreshold = Constants.leaderboardViewPreviewHeight - Constants.pullTabPanThreshold
        let leaderboardViewMaxHeight = view.bounds.height - chatInputView.bounds.height
        
        switch gestureRecognizer.state {
        case .began:
            if leaderboardViewHeightConstraint.constant > Constants.leaderboardViewPreviewHeight {
                chatViewIsHidden = true
            } else if leaderboardViewHeightConstraint.constant <= Constants.leaderboardViewPreviewHeight {
                chatViewIsHidden = false
            }
            fallthrough
        case .changed:
            leaderboardViewHeightConstraint.constant += yTranslation
            gestureRecognizer.setTranslation(.zero, in: pullTabView)
        case .ended:
            if leaderboardViewHeightConstraint.constant < chatViewHideThreshold &&
                leaderboardViewHeightConstraint.constant > chatViewExpandThreshold {
                // Tab was not pulled far enough from the middle state to expand or hide the chat view,
                // so reset it to the middle state
                textView.resignFirstResponder()
                leaderboardViewHeightConstraint.constant = Constants.leaderboardViewPreviewHeight
            }
            
            if leaderboardViewHeightConstraint.constant > chatViewHideThreshold && !chatViewIsHidden {
                // Expand leaderboard view to max height and hide keyboard
                textView.resignFirstResponder()
                leaderboardViewHeightConstraint.constant = leaderboardViewMaxHeight
            } else if leaderboardViewHeightConstraint.constant < chatViewExpandThreshold {
                // Hide leaderboard view
                leaderboardViewHeightConstraint.constant = Constants.leaderboardViewMinimumHeight
            } else if leaderboardViewHeightConstraint.constant < leaderboardViewMaxHeight - Constants.pullTabPanThreshold {
                // If chat view was hidden and the tab was pulled up past the pan threshold,
                // expand the chat view
                leaderboardViewHeightConstraint.constant = Constants.leaderboardViewPreviewHeight
            }
            UIView.animate(withDuration: Constants.panAnimationInterval) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        default:
            return
        }
    }
    
}
