//
//  UIView+PinEdges.swift
//  WeatherForecast
//
//  Created by mac on 02.05.2023.
//

import UIKit

extension UIView {
  
  func pinEdgesToSuperView(_ distance: CGFloat = 0) {
    guard let superView = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superView.topAnchor, constant: distance),
      leftAnchor.constraint(equalTo: superView.leftAnchor, constant: distance),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -distance),
      rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -distance)
    ])
  }
  
  func pinEdgesToSuperView(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
    guard let superView = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superView.topAnchor, constant: top),
      leftAnchor.constraint(equalTo: superView.leftAnchor, constant: left),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottom),
      rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -right)
    ])
  }
}
