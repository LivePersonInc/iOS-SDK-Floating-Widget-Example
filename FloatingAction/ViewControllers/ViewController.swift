//
//  ViewController.swift
//  FloatingAction
//
//  Created by David Villacis on 1/10/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LivePersonAPIDelegate {
  
  // MARK: - App Properties
  
  public var chatFloatingButton : FloatingAction!
  
  // MARK: - App LifeCycle
  
  /// App LifeCycle - View did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Init LivePersonAPI Delegate
    LivePersonAPI.shared.delegate = self
    // Add Floating Action
    self.addFloatingActionButton()
  }
  
  /// App LifeCycle - Receive Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  /// App LifeCycle - View will Appear
  override func viewWillAppear(_ animated: Bool) {
    // Super Init
    super.viewDidAppear(animated)
    // Get Unread Messages Count
    LivePersonAPI.shared.getUnreadMessagesCount()
  }
  
  /// App LifeCycle - View did Appear
  override func viewDidAppear(_ animated: Bool) {
    // Super Init
    super.viewDidAppear(animated)
  }
    
  /// Will Create new Floating Action Button
  private func addFloatingActionButton(){
    // Create new Floating Action Button
    self.chatFloatingButton = FloatingAction()
    
    // Create Gesture Recognizer
    let gesture = UITapGestureRecognizer(target: self, action: #selector(showMessagingScreen(_:)))
    // Add Gesture to Floating Action
    self.chatFloatingButton.addGestureRecognizer(gesture)
    
    // Set Button Frame
    self.chatFloatingButton.frame = CGRect(x: 330.0, y: 330.0, width: 60.0, height: 60.0)
    // TODO: Floating Action Tag - Will be needed to Update Counter from AppDelegate
    self.chatFloatingButton.tag = self.chatFloatingButton.actionTag
    // TODO: Set if ViewController has NavigationBar, this to set a MaxY to the Dragging, so the Floating Action is always visible
    self.chatFloatingButton.hasNavigationBar = true
    // INFO: Helps to Calculate dragging Boundaries
    self.chatFloatingButton.navigationBarHeight = (self.navigationController?.navigationBar.frame.height)!
    // Set Background Image
    self.chatFloatingButton.image = UIImage(named: "MessagingIcon")
    // Set Button Background Color
    self.chatFloatingButton.backgroundColor = UIColor.turquoise
    // INFO : To change the Background Color of the Notification Badge : Default to Red
    self.chatFloatingButton.badgeBackgroundColor = UIColor.red
    // INFO : To change the Border Color of the Notification Badge  : Default to White
    self.chatFloatingButton.badgeBorderColor = UIColor.white
    // Add Button to View
    self.view.addSubview(self.chatFloatingButton)
    // INFO : More Customizations will need to be change on the FloatingAction Class
  }
  
  /// Will show Messaging Screen
  ///
  /// - Parameter sender: Gesture
  @objc func showMessagingScreen(_ sender : UITapGestureRecognizer ){
    // Change Alpha
    self.chatFloatingButton.alpha = 0.8
    // Reference ConversationViewController
    let conversationViewController = storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
    // Show ConversationViewController
    self.navigationController?.pushViewController(conversationViewController!, animated: true)
    // Restore Alpha
    self.chatFloatingButton.alpha = 1.0
  }
  
  // MARK: - LivePersonAPI Delegate
  
  /// Will return Unread Messages Count from LPMessagingSDK
  func didFinishFetchgingUnreadMessagesCount(_ count: Int) {
    // Update Badge
    self.updateUnreadMessagesBadge(count)
  }
  
  // MARK: - Notification Counter
  
  /// Will Update Unread Notification Counter on UIFloating Action
  ///
  /// - Parameter count: Unread Notification Counter
  func updateUnreadMessagesBadge(_ count: Int) {
    // Set Notification Counter
    self.chatFloatingButton.setCounterWithInt(count)
  }
}

