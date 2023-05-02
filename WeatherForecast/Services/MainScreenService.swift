//
//  MainScreenService.swift
//  WeatherForecast
//
//  Created by mac on 30.04.2023.
//
// https://api.openweathermap.org/data/2.5/weather?&appid=ef051bc0fd49e2d695fdc3e3983c646e&units=metric&lat=37.5485&lon=-121.9886

import Foundation
import CoreLocation

protocol MainScreenServiceDelegate {
  func didUpdateWeather(_ weatherService: MainScreenService, weatherModel: MainScreenModel)
  func didFailWithError(error: Error)
}

struct MainScreenService {
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=ef051bc0fd49e2d695fdc3e3983c646e&units=metric"
  var delegate: MainScreenServiceDelegate?
  
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
  
  func parseJSON(_ weatherData: Data) -> MainScreenModel? {
    let decoder = JSONDecoder()
    do {
      
      let decodedData = try decoder.decode(MainScreenResponse.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name
      
      let weather = MainScreenModel(cityName: name, temperature: temp, icon: id)
      return weather
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
