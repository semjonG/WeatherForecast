//
//  ForecastScreenService.swift
//  WeatherForecast
//
//  Created by mac on 02.05.2023.
//
//https://api.openweathermap.org/data/2.5/onecall?&appid=ef051bc0fd49e2d695fdc3e3983c646e&units=metric&exclude=minutely,hourly&lat=37.5485&lon=-121.9886

import Foundation
import CoreLocation

protocol ForecastScreenServiceDelegate {
  func didUpdateWeather(_ weatherService: ForecastScreenService, weatherModel: ForecastScreenModel)
  func didFailWithError(error: Error)
}

struct ForecastScreenService {
  let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&appid=ef051bc0fd49e2d695fdc3e3983c646e&units=metric&exclude=minutely,hourly"
  var delegate: ForecastScreenServiceDelegate?
  
  func fetchWeather(cityName: String) {
    let urlString = "\(weatherURL)&q=\(cityName)"
    performRequest(with: urlString)
  }

  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String) {
    //1. Create a URL
    if let url = URL(string: urlString) {
      
      //2. Create a URLSession
      let session = URLSession(configuration: .default)
      
      //3. Give the session a task
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weatherModel: weather)
          }
        }
      }
      //4. Start the task
      task.resume()
    }
  }
  
  func parseJSON(_ weatherData: Data) -> ForecastScreenModel? {
    let decoder = JSONDecoder()
    do {
      
      let decodedData = try decoder.decode(ForecastScreenResponse.self, from: weatherData)
      
      let date = decodedData.daily[0].date
      let minTemp = decodedData.daily[0].temperature.min
      let maxTemp = decodedData.daily[0].temperature.max
      
      let weather = ForecastScreenModel(date: date, minTemperature: minTemp, maxTemperature: maxTemp)
      return weather
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}

