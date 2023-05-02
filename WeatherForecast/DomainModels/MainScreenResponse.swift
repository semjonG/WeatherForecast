//
//  MainScreenResponse.swift
//  WeatherForecast
//
//  Created by mac on 30.04.2023.
//

import Foundation

struct MainScreenResponse: Codable {
  let name: String
  let main: Main
  let weather: [WeatherDescription]
}

struct Main: Codable {
  let temp: Double
}

struct WeatherDescription: Codable {
  let description: String
  let id: Int
}
