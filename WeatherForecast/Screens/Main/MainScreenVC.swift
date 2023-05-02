//
//  MainScreenVC.swift
//  WeatherForecast
//
//  Created by mac on 29.04.2023.
//

import UIKit
import CoreLocation

class MainScreenVC: UIViewController {
  
  lazy var searchTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Enter city name"
    textField.textAlignment = .left
    textField.returnKeyType = .search
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  lazy var searchButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var cityLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  lazy var temperatureLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    return label
  }()
  
  lazy var conditionImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  lazy var locationButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 8
    button.tintColor = .white
    
    let iconAttachment = NSTextAttachment()
    iconAttachment.image = UIImage(systemName: "location.fill")?.withTintColor(.white)
    let attributedString = NSMutableAttributedString(string: "Update location ")
    attributedString.append(NSAttributedString(attachment: iconAttachment))
    button.setAttributedTitle(attributedString, for: .normal)
    
    button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
    return button
  }()
  
  private var mainScreenService = MainScreenService()
  private let locationManager = CLLocationManager()
   
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    mainScreenService.delegate = self
    searchTextField.delegate = self
    view.backgroundColor = .white
    setupViews()
  }
  
  //MARK: - Private methods
  private func setupViews() {
    let stackView = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, conditionImageView, locationButton])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 32
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(searchTextField)
    view.addSubview(searchButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -16),
      searchTextField.heightAnchor.constraint(equalToConstant: 44),
      
      searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor),
      searchButton.widthAnchor.constraint(equalToConstant: 36),
      searchButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
      
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      cityLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      cityLabel.heightAnchor.constraint(equalToConstant: 36),
      
      temperatureLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      temperatureLabel.heightAnchor.constraint(equalToConstant: 44),
      
      conditionImageView.widthAnchor.constraint(equalToConstant: 44),
      conditionImageView.heightAnchor.constraint(equalToConstant: 44),
      
      locationButton.heightAnchor.constraint(equalToConstant: 36),
      locationButton.widthAnchor.constraint(equalToConstant: 180)
    ])
  }
  
  //MARK: - Actions
  @objc func locationButtonPressed() {
    locationManager.requestLocation()
    
    UIView.animate(withDuration: 0.2, animations: {
      self.locationButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      self.locationButton.backgroundColor = .systemBlue.withAlphaComponent(0.8)
    }, completion: { _ in
      UIView.animate(withDuration: 0.2) {
        self.locationButton.transform = .identity
        self.locationButton.backgroundColor = .systemBlue
      }
    })
  }
}

//MARK: - UITextFieldDelegate
extension MainScreenVC: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Enter city name"
      return false
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text {
      mainScreenService.fetchWeather(cityName: city)
    }
    searchTextField.text = ""
  }
  
  @objc private func searchButtonPressed() {
    searchTextField.endEditing(true)
  }
}

//MARK: - MainScreenServiceDelegate
extension MainScreenVC: MainScreenServiceDelegate {
  
  func didUpdateWeather(_ weatherService: MainScreenService, weatherModel: MainScreenModel) {
    DispatchQueue.main.async {
      self.temperatureLabel.text = weatherModel.temperatureString
      self.conditionImageView.image = UIImage(systemName: weatherModel.conditionId)
      self.cityLabel.text = weatherModel.cityName
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}

//MARK: - CLLocationManagerDelegate
extension MainScreenVC: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      mainScreenService.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
