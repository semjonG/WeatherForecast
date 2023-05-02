//
//  ForecastScreenResponse.swift
//  WeatherForecast
//
//  Created by mac on 02.05.2023.
//

import Foundation

///Первоначальный блок с полями, который приходит с сервера.
struct ForecastScreenResponse: Codable {
  let daily: [DailyWeather]
}

/// Это блок поля "daily", который лежит внутри ForecastScreenResponse - первоначального блока
struct DailyWeather: Codable {
  let date: Int
  let temperature: Temperature

  enum CodingKeys: String, CodingKey {
    case date = "dt"
    case temperature = "temp"
  }
}

/// Блок "temp" внутри блока "daily"
struct Temperature: Codable {
  let min: Double
  let max: Double
}
