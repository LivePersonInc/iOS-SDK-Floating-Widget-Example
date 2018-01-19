//
//  UIFloatingAction.swift
//  FloatingAction
//
//  Created by David Villacis on 1/10/18.
//  Copyright © 2018 David Villacis. All rights reserved.
//
import UIKit
import ObjectiveC


class FloatingAction: UIView, UIGestureRecognizerDelegate {
  
  // MARK: - Properties
  
  // Button Background Image
  public var imageView : UIImageView!
  // Notification Badge
  public var badge : UILabel?
  // Background Image
  public var image : UIImage? {
    didSet{ imageView.image = image }
  }
  // Badge Background Color
  public var badgeBackgroundColor : UIColor = UIColor.red {
    // Set Badge Background Color
    didSet{ self.badge!.backgroundColor = badgeBackgroundColor }
  }
  // Badge Border Color
  public var badgeBorderColor : UIColor = UIColor.clear {
    // Change Border Color
    didSet{ setBadgeBoderColor(badgeBorderColor) }
  }
  // Initial Location of Floating Action
  var beginLocation: CGPoint?
  // Long Press Gesture
  var longPressGesture: UILongPressGestureRecognizer?
  // Tap Gesture Recognizer
  var touchUpInside : UITapGestureRecognizer?
  // Long Press Block Func
  var longPressBlock:(()->Void)?
  // TODO: Floating Action Tag - Will be needed to Update Counter from AppDelegate
  public let actionTag = 587777
  // TODO: Flag to Check if View has Navigation Bar
  public var hasNavigationBar : Bool = true
  // TODO: Will Store Navigation Bar Height
  public var navigationBarHeight : CGFloat = 44.0
  
  // MARK: - Initializers
  
  /// Default Init
  ///
  /// - Parameter frame: Frame
  override init(frame: CGRect) {
    // Super Init
    super.init(frame: frame)
    // Add Subviews
    self.addSubviews()
  }
  
  /// Require Init Coder
  required init?(coder aDecoder: NSCoder) {
    // Super Init
    super.init(coder: aDecoder)
  }
  
  /// Will Awake from NIB
  override func awakeFromNib() {
    // Init Super Class
    super.awakeFromNib()
    // Create Long Gesture Recognizer
    self.longPressGesture = UILongPressGestureRecognizer()
    // Add Gesture Delegate
    self.longPressGesture?.delegate = self
    // Add Selector to Gesture
    self.longPressGesture!.addTarget(self, action: #selector(draggingHandler(_:)))
    // Add Gesture to Button
    self.addGestureRecognizer(self.longPressGesture!)
  }
  
  // MARK: - Subview Methods
  
  /// Init Layout Subviews
  override func layoutSubviews() {
    // Init Super Class
    super.layoutSubviews()
    // Set Corner Radius
    layer.cornerRadius = (self.frame.width/2.0)
    // Mask to Bounds, if (self.frame.width/2.0) > 0
    layer.masksToBounds = (self.frame.width/2.0) > 0
  }
  
  /// Will add SubViews to main View
  private func addSubviews() {
    // Check if Badge has been set
    if self.badge == nil {
      // Init Badge Label
      self.badge = UILabel()
    }
    // Check if ImageView has been set
    if self.imageView == nil {
      // Init Image View - Button Background Image
      self.imageView = UIImageView()
    }
    // Add ImageView to UIView
    addSubview(self.imageView)
    // Add Badge to UIView
    addSubview(self.badge!)
    // Set Image Content Mode
    self.imageView.contentMode = UIViewContentMode.scaleAspectFill
    // Add UIImageView Constrains - Button Background Image
    self.addImageViewConstrains()
    // Add Badge Properties
    self.setBadgeLabelProperties()
  }
  
  // MARK: - Setters/Getters
  
  /// Will set Badge Round Borders for Notification Badge
  private func setBadgeBorders(){
    // Set Corner Radius
    self.badge!.layer.cornerRadius = (self.badge!.frame.width/2.0)
    // Mask to Bounds, if (self.frame.width/2.0) > 0
    self.badge!.clipsToBounds = true
  }
  
  /// Will change Badge Counter
  ///
  /// - Parameter counter: Notification Counter
  public func setCounter(_ counter : String?){
    // Check Counter
    if counter == nil  || counter == "" {
      // Change Badge Counter Text
      self.badge!.text = "0"
      // Hide Badge
      self.badge!.isHidden = true
    } else {
      // Change Badge Counter Text
      self.badge!.text = counter!
      // Show Badge
      self.badge!.isHidden = false
    }
    // Set Badge Rounded Borders
    self.setBadgeBorders()
    // Add Badge Constrains - Counter
    // self.addBadgeConstrains()
  }
  
  /// Will change Badge Counter with Int
  ///
  /// - Parameter counter: Notification Counter
  public func setCounterWithInt(_ counter : Int){
    // Check Counter
    if counter == 0 {
      // Change Badge Counter Text
      self.badge!.text = "0"
      // Hide Badge
      self.badge!.isHidden = true
    } else {
      // Change Badge Counter Text
      self.badge!.text = "\(counter)"
      // Show Badge
      self.badge!.isHidden = false
    }
    // Set Badge Rounded Borders
    self.setBadgeBorders()
    // Add Badge Constrains - Counter
    // self.addBadgeConstrains()
  }
  
  /// Will add/change Badge Border Color
  ///
  /// - Parameter color: Color
  public func setBadgeBoderColor(_ color : UIColor = UIColor.white, borderWidth : CGFloat = 1.0){
    // Change Badge Border Color
    self.badge!.layer.borderColor = color.cgColor
    // Ad Badge Border Width
    self.badge!.layer.borderWidth = borderWidth
  }
  
  /// Will add properties for Badge UILabel
  private func setBadgeLabelProperties(){
    // Set Badge Backgroud Color
    self.badge!.backgroundColor = badgeBackgroundColor
    // Center Text on Badge
    self.badge!.textAlignment = .center
    // Set Badge Text Color
    self.badge!.textColor = UIColor.white
    // Set Badge Font Size
    self.badge!.font = UIFont(name: "Helvetica", size: 8.0)
    // Set Number of Lines
    self.badge!.numberOfLines = 0
    // Set Font Size to Fit
    self.badge!.adjustsFontSizeToFitWidth = true
    // Scale Factor
    self.badge!.minimumScaleFactor = 0.2
    // Set Content Scale
    self.badge!.contentScaleFactor = UIScreen.main.scale
    // By default Badge is Hidden
    self.badge!.isHidden = true
    // Add Badge Constrains - Counter
    self.addBadgeConstrains()
    // Add Badge Border
    self.setBadgeBoderColor()
    // Set Badge Rounded Borders
    self.setBadgeBorders()
  }
  
  // MARK: - Constrains
  
  /// Will add Constrains to ImageView (Button Background Image)
  private func addImageViewConstrains(){
    // Cancel Autoresizing Mask
    self.imageView.translatesAutoresizingMaskIntoConstraints = false
    // This constraint centers the imageView Horizontally in the View
    let centerX = NSLayoutConstraint(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    // This constraint centers the imageView Vertically in the View
    let centerY = NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    // You should also set some constraint about the height of the imageView
    // or attach it to some item placed right under it in the view such as the
    // BottomMargin of the parent view or another object's Top attribute.
    let height = NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1.0, constant: (self.frame.width/3))
    let width = NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 1.0, constant: (self.frame.width/3))
    // Activate the constraints
    self.addConstraints([centerX, centerY, height, width])
  }
  
  /// Will add Constrains to Badge Label (Notification Counter)
  private func addBadgeConstrains(){
    // Cancel Autoresizing Mask
    self.badge!.translatesAutoresizingMaskIntoConstraints = false
    // This constraint sets the Badge Button Edge to the ImageView Top Edge
    let bottom = NSLayoutConstraint(item: self.badge!, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .top, multiplier: 1.50, constant: 1.0)
    // This constraint sets the Badge Leading Edge to the ImageView Trailing Edge
    let trailing = NSLayoutConstraint(item: self.badge!, attribute: .leading, relatedBy: .equal, toItem: self.imageView, attribute: .trailing, multiplier: 0.75, constant: 1.0)
    // You should also set some constraint about the height of the imageView
    // or attach it to some item placed right under it in the view such as the
    // BottomMargin of the parent view or another object's Top attribute.
    let height = NSLayoutConstraint(item: self.badge!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.01, constant: 14)
    let width = NSLayoutConstraint(item: self.badge!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.01, constant: 14)
    // Activate the constraints
    self.addConstraints([height, width, bottom, trailing])
  }
  
  // MARK: - Touch Events
  
  /// Dragging Handler = User is Dragging Floating Action
  ///
  /// - Parameter gestureRecognizer: Gesture
  @objc func draggingHandler(_ gestureRecognizer: UILongPressGestureRecognizer){
    // Check for Gesture Recognizer State
    switch gestureRecognizer.state {
    // Touches Began
    case .began:
      // Lock LongPress
      if let longPressBlock = self.longPressBlock {
        // Lock LongPress
        longPressBlock()
      }
      break
    default:
      break
    }
  }
  
  /// Will catch Initial Touch
  ///
  /// - Parameters:
  ///   - touches: Touches
  ///   - event: Event Type
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Init Super Class
    super.touchesBegan(touches, with: event)
    // Get Touch
    let touch: UITouch? = (touches as NSSet).anyObject() as? UITouch
    // Save Original Location
    self.beginLocation = touch?.location(in: self)
    // Change Alpha
    self.alpha = 0.8
  }
  
  /// Will catch Dragging of UIFloatingAction
  ///
  /// - Parameters:
  ///   - touches: Touches
  ///   - event: Event Type
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Get Touch
    let touch: UITouch? = (touches as NSSet).anyObject() as? UITouch
    // Get Current Location
    let currentLocation = touch?.location(in: self)
    // Calculate X-Offset
    let offsetX : CGFloat? = (currentLocation?.x)! - (self.beginLocation?.x)!
    // Calculate Y-Offset
    let offsetY : CGFloat? = (currentLocation?.y)! - (self.beginLocation?.y)!
    // Set Center
    self.center = CGPoint(x: self.center.x + offsetX!, y: self.center.y + offsetY!)
    // Get Main View Frame
    let mainView : CGRect? = self.superview?.frame
    // Get Frame
    let frame = self.frame
    // Calculate X-Left Limit
    let leftLimitX: CGFloat = frame.size.width / 2.0
    // Calculate X-Right Limit
    let rightLimitX: CGFloat? = (mainView?.size.width)! - leftLimitX
    // Calculate Y-Top Limit
    let topLimitY: CGFloat = (frame.size.height) / 2.0
    // Max Position on Top-X
    let maxTop : CGFloat
    // Check if there is a Navigation Bar
    if self.hasNavigationBar {
      // Calculate Max-Y-Top Limit
      maxTop = (frame.size.height + self.navigationBarHeight) / 2.0
    } else {
      // Calculate Max-Y-Top Limit
      maxTop = frame.size.height / 2.0
    }
    // Calculate Y-Bottom Limit
    let bottomLimitY: CGFloat? = (mainView?.size.height)! - topLimitY
    // Check if Center > X-Right Limit
    if (self.center.x > rightLimitX!) {
      // Move Center to New Position
      self.center = CGPoint(x: rightLimitX!, y: self.center.y)
      // Check if Center <= X-Left Limit
    } else if (self.center.x <= leftLimitX) {
      // Move Center to New Position
      self.center = CGPoint(x: leftLimitX, y: self.center.y)
    }
    // Check if Center > Y-Bottom Limit
    if (self.center.y > bottomLimitY!) {
      // Move Center to New Position
      self.center = CGPoint(x: self.center.x, y: bottomLimitY!)
      // Check if Center > Y-Top Limit
    } else if (self.center.y <= maxTop) {
      // Move Center to New Position
      self.center = CGPoint(x: self.center.x, y: maxTop)
    }
  }
  
  /// Will catch Final Touch
  ///
  /// - Parameters:
  ///   - touches: Touches
  ///   - event: Event Type
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Init Super Class
    super.touchesEnded(touches, with: event)
    // Get Touch
    let touch: UITouch? = (touches as NSSet).anyObject() as? UITouch
    // Save Original Location
    self.beginLocation = touch?.location(in: self)
    // Reset Alpha
    self.alpha = 1.0
  }
}

