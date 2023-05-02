//
//  MainScreenModel.swift
//  WeatherForecast
//
//  Created by mac on 30.04.2023.
//

import Foundation

struct MainScreenModel {
  let cityName: String
  let temperature: Double
  let icon: Int
  
  var temperatureString: String {
    return String(format: "%.1f ℃", temperature)
  }
  
  var conditionId: String {
    switch icon {
    case 200...232:
      return "cloud.bolt"
    case 300...321:
      return "cloud.drizzle"
    case 500...531:
      return "cloud.rain"
    case 600...622:
      return "cloud.snow"
    case 701...781:
      return "cloud.fog"
    case 800:
      return "sun.max"
    case 801...804:
      return "cloud.bolt"
    default:
      return "cloud"
    }
  }
}


