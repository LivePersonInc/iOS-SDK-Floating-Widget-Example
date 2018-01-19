//
//  LivePersonAPI.swift
//  FloatingAction
//
//  Created by David Villacis on 1/12/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import Foundation
// Required LP Imports
import LPMessagingSDK
import LPInfra

// LivePerson API Delegate
protocol LivePersonAPIDelegate : class {
  /// Wil return Unread Messages Count
  ///
  /// - Parameter count: Messages Count
  func didFinishFetchgingUnreadMessagesCount(_ count : Int)
}

class LivePersonAPI : NSObject {
  
  //MARK: - Properties
  
  static let shared = LivePersonAPI()
  // Reference to LivePersonAPI Delegate
  weak var delegate : LivePersonAPIDelegate?
  
  /// Avoid Default Init
  override init(){}
  
  /// Will return Unread Messages Count from LPMessagingSDK
  public func getUnreadMessagesCount(){
    // Check if Conversation Query is not nil
    if LivePersonSDK.shared.conversationQuery != nil{
      // Get Unreadn Messages Count from LPMessaging SDK
      LPMessagingSDK.getUnreadMessagesCount(LivePersonSDK.shared.conversationQuery!, completion: { (count) in
        // Log
        print("Unread Count:: ", count)
        // Send Count to Delegate
        self.delegate?.didFinishFetchgingUnreadMessagesCount(count)
      }, failure: { (error) in
        // Log
        print("Error:: ", error.localizedDescription)
      })
    }
  }
}
