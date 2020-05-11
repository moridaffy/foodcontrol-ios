//
//  RootViewControllerManager.swift
//  RVCManagerExample
//
//  Created by Максим Скрябин on 25/04/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

public class RootViewControllerManager {
  
  public static let shared = RootViewControllerManager()
  private var isTransitioning: Bool = false
  
  public func change(to nextViewController: UIViewController, withAnimation: AnimationType? = nil, animationDuration: Double? = nil, completion: (() -> Void)? = nil) {
    let animationType = withAnimation ?? .none
    guard !isTransitioning else { return }
    guard let window = UIApplication.shared.keyWindow,
          let currentViewController = window.rootViewController else { fatalError("Application has no root view controller") }
    
    nextViewController.overrideUserInterfaceStyle = .light
    nextViewController.view.frame = window.bounds
    guard let nextSnapshot = nextViewController.view.snapshotView(afterScreenUpdates: true), animationType != .none else {
      window.rootViewController = nextViewController
      completion?()
      return
    }
    
    switch animationType {
    case .verticalUp, .verticalDown:
      nextSnapshot.transform = CGAffineTransform(translationX: 0.0, y: nextSnapshot.frame.height * (animationType == .verticalUp ? 1.0 : -1.0))
    case .horizontalLeft, .horizontalRight:
      nextSnapshot.transform = CGAffineTransform(translationX: nextSnapshot.frame.width * (animationType == .horizontalLeft ? 1.0 : -1.0), y: 0.0)
    case .fade:
      nextSnapshot.alpha = 0.0
    default:
      break
    }
    isTransitioning = true
    window.addSubview(nextSnapshot)
    
    UIView.animate(withDuration: animationDuration ?? animationType.duration, animations: {
      switch animationType {
      case .verticalUp, .verticalDown:
        currentViewController.view.transform = CGAffineTransform(translationX: 0.0, y: currentViewController.view.frame.height * (animationType == .verticalUp ? -1.0 : 1.0))
        nextSnapshot.transform = CGAffineTransform.identity
      case .horizontalLeft, .horizontalRight:
        currentViewController.view.transform = CGAffineTransform(translationX: currentViewController.view.frame.width * (animationType == .horizontalLeft ? -1.0 : 1.0), y: 0.0)
        nextSnapshot.transform = CGAffineTransform.identity
      case .fade:
        nextSnapshot.alpha = 1.0
      default:
        break
      }
    }) { (_) in
      window.rootViewController = nextViewController
      nextSnapshot.removeFromSuperview()
      self.isTransitioning = false
      completion?()
    }
  }
  
}

public extension RootViewControllerManager {
  enum AnimationType: Int {
    case verticalUp
    case verticalDown
    case horizontalRight
    case horizontalLeft
    case fade
    case none
    
    var duration: Double {
      switch self {
      case .none:
        return 0.0
      case .fade:
        return 0.5
      default:
        return 0.8
      }
    }
  }
}
