//
//  UIView+LivePerson.swift
//  FloatingAction
//
//  Created by David Villacis on 1/10/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import UIKit

extension UIView {
  
  /// Will provide handeling for which type of Device is been use
  struct Device {
    // Device Detection - iPad
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    // Device Detection - iPhone
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    // Device Detection - Retina Display
    static let IS_RETINA = UIScreen.main.scale >= 2.0
    
    // Device Detection - Screen Width
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    // Device Detection - Screen Height
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    // Device Detection - Screen Max Lenght
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    // Device Detection - Min Lenght
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    // Device Detection - iPhone X
    static let IS_IPHONE_X = IS_IPHONE && SCREEN_MAX_LENGTH == 812
  }
}
