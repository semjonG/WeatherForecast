//
//  ForecastScreenVC.swift
//  WeatherForecast
//
//  Created by mac on 02.05.2023.
//

import CoreLocation
import UIKit

final class ForecastScreenVC: UIViewController {

  var dailyWeatherService = ForecastScreenService()
  var dailyWeather: [ForecastScreenModel] = []
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = UIColor.clear
    tableView.register(ForecastScreenCell.self, forCellReuseIdentifier: ForecastScreenCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    self.view.addSubview(tableView)
    tableView.pinEdgesToSuperView()
  }
}

extension ForecastScreenVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dailyWeather.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: ForecastScreenCell = tableView.dequeueReusableCell(withIdentifier: ForecastScreenCell.identifier, for: indexPath) as! ForecastScreenCell
    
    let dailyWeather = dailyWeather[indexPath.row]
    cell.configure(dailyWeather)
    cell.selectionStyle = .none
    return cell
  }
}

extension ForecastScreenVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.2, animations: {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.frame = CGRect(x: (cell?.frame.origin.x)!-15,
                                 y: (cell?.frame.origin.y)!,
                                 width: cell!.bounds.size.width,
                                 height: cell!.bounds.size.height)

        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.frame = CGRect(x: (cell?.frame.origin.x)!+15,
                                     y: (cell?.frame.origin.y)!,
                                     width: cell!.bounds.size.width,
                                     height: cell!.bounds.size.height)
            })
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
