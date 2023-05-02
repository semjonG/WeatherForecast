//
//  TabBarController.swift
//  WeatherForecast
//
//  Created by mac on 30.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
  private let mainScreenVC = MainScreenVC()
  private let foreCastScreenVC = ForecastScreenVC()
  private let mainTabBar = UITabBarItem()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainScreenVC.tabBarItem.image = UIImage(systemName: "location")
    mainScreenVC.tabBarItem.title = "Main"
    foreCastScreenVC.tabBarItem.image = UIImage(systemName: "calendar")
    foreCastScreenVC.tabBarItem.title = "Forecast"
    
    let navigationMainScreenVC = UINavigationController(rootViewController: mainScreenVC)
    let navigationForecastScreenVC = UINavigationController(rootViewController: foreCastScreenVC)
    
    let controllers = [navigationMainScreenVC, navigationForecastScreenVC]
    self.viewControllers = controllers
    
    setupMiddleButton()
  }
  
  func setupMiddleButton() {
    let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    var menuButtonFrame = menuButton.frame
    menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
    menuButton.frame = menuButtonFrame

    menuButton.layer.shadowColor = UIColor.black.cgColor
    menuButton.layer.shadowOpacity = 0.4
    menuButton.layer.shadowOffset = CGSize(width: 0, height: 2)
    menuButton.layer.shadowRadius = 4
    menuButton.layer.masksToBounds = false
    
    menuButton.backgroundColor = UIColor.systemBlue
    menuButton.layer.cornerRadius = menuButtonFrame.height/2
    view.addSubview(menuButton)
    
    let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))?.withTintColor(.white, renderingMode: .alwaysOriginal)
    menuButton.setImage(plusImage, for: .normal)
    
    menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
    
    view.layoutIfNeeded()
  }
  
  // MARK: - Actions
  @objc private func menuButtonAction(sender: UIButton) {
      selectedIndex = 2
  }
  
  // tabBarItem animation
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let barItemView = item.value(forKey: "view") as? UIView else { return }
    
    let timeInterval: TimeInterval = 0.3
    let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
      barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
    }
    propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
    propertyAnimator.startAnimation()
  }
}
