//
//  UIColor+LivePerson.swift
//  FloatingAction
//
//  Created by David Villacis on 1/10/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import UIKit

public extension UIColor {
  
  /// Get Lighter version of given UIColor
  ///
  /// - Parameter percentage: Percentage to Adjust
  /// - Returns: Lighter UIColor
  func lighter(by percentage:CGFloat=30.0) -> UIColor? {
    return self.adjust(by: abs(percentage) )
  }
  
  /// Get Darker version of given UIColor
  ///
  /// - Parameter percentage: Percentage to Adjust
  /// - Returns: Lighter UIColor
  func darker(by percentage:CGFloat=30.0) -> UIColor? {
    return self.adjust(by: -1 * abs(percentage) )
  }
  
  /// Get Adjust version of given UIColor
  ///
  /// - Parameter percentage: Percentage to Adjust
  /// - Returns: Lighter UIColor
  func adjust(by percentage:CGFloat=30.0) -> UIColor? {
    // Create new Color Vars
    var red : CGFloat=0, green : CGFloat=0, blue : CGFloat=0, alpha : CGFloat=0
    // Check Red Color
    if(self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)){
      // Return Color with new Colors
      return UIColor(red: min(red + percentage/100, 1.0),
                     green: min(green + percentage/100, 1.0),
                     blue: min(blue + percentage/100, 1.0),
                     alpha: alpha)
    }else{
      // Retun Nil
      return nil
    }
  }
  
  /// LivePerson - Tangerine
  @objc static var tangerine : UIColor {
    return UIColor(red:1, green:0.5843, blue:0.1333, alpha:1.0)
  }
  
  /// LivePerson - Light Tangerine
  @objc static var lightTangerine : UIColor {
    return UIColor(red:1, green:0.73, blue:0.50, alpha:1.0)
  }
  
  /// LivePerson - Light Tangerine
  @objc static var turquoise : UIColor {
    return UIColor(red:0.29, green:0.51, blue:0.52, alpha:1.0)
  }
}
