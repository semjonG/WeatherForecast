//
//  ForecastScreenCell.swift
//  WeatherForecast
//
//  Created by mac on 02.05.2023.
//

import UIKit

final class ForecastScreenCell: UITableViewCell {
  
  static let identifier = "ForecastScreenCell"
  
  lazy var backView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    return view
  }()
  
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  lazy var minTemperatureLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  lazy var maxTemperatureLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - cell shadow
  override func layoutSubviews() {
    contentView.backgroundColor = UIColor.clear
    backgroundColor = UIColor.clear
    backView.layer.cornerRadius = 25
    backView.clipsToBounds = true
    
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = .zero
  }
  
  // MARK: - Public
  func configure(_ screenModel: ForecastScreenModel) {
    self.dateLabel.text = "\(getDayFor(timestamp: screenModel.date))"
    self.minTemperatureLabel.text = "\(getTemperatureFor(temperature: screenModel.minTemperature)) ℃"
    self.maxTemperatureLabel.text = "\(getTemperatureFor(temperature: screenModel.maxTemperature)) ℃"
  }
  
  // MARK: - Private
  private func setupViews() {
    contentView.addSubview(backView)
    contentView.addSubview(dateLabel)
  }
  
  private lazy var dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "EEE"
    return formatter
  }()

  private func getDayFor(timestamp: Int) -> String {
    return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
  }
  
  private func getTemperatureFor(temperature: Double) -> String {
    String(format: "%0.1f", temperature)
  }
  
  private func setupConstraints() {
    backView.pinEdgesToSuperView(top: 10, bottom: 10, left: 20, right: 20)

    NSLayoutConstraint.activate([
      dateLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
      dateLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
      dateLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
      
      dateLabel.widthAnchor.constraint(equalToConstant: 80),
      dateLabel.heightAnchor.constraint(equalToConstant: 36),
      
      minTemperatureLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
      minTemperatureLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor),
      minTemperatureLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
      minTemperatureLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
      
      minTemperatureLabel.widthAnchor.constraint(equalToConstant: 80),
      minTemperatureLabel.heightAnchor.constraint(equalToConstant: 36),
      
      maxTemperatureLabel.leadingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor),
      maxTemperatureLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
      maxTemperatureLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
      maxTemperatureLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
      
      maxTemperatureLabel.widthAnchor.constraint(equalToConstant: 80),
      maxTemperatureLabel.heightAnchor.constraint(equalToConstant: 36)
    ])
  }
}


