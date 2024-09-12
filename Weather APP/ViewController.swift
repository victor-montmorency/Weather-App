//
//  ViewController.swift
//  Weather APP
//
//  Created by victor mont-morency on 08/09/24.
//

import UIKit


class ViewController: UIViewController {
    
    
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var switchLocationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "editIcon")
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("trocar localização", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = .contrastColor
        button.addTarget(self, action: #selector(showStates), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.colorContrast
        
        return label
    } ()
    
    private lazy var cityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityLabel, switchLocationButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    } ()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.colorContrast
        return label
    } ()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ("Humidade")
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        return label
    } ()
    
    private lazy var humidityValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        return label
    } ()
    
    private lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityLabel, humidityValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    } ()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ("Vento")
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        return label
    } ()
    
    private lazy var windValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.contrastColor
        return label
    } ()
    
    private lazy var windStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windLabel, windValueLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    } ()
    
    private lazy var statsStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [humidityStackView, windStackView])
        stackview.axis = .vertical
        stackview.spacing = 3
        stackview.backgroundColor = UIColor.clear
        stackview.layer.cornerRadius = 10
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    } ()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.contrastColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "PREVISÃO POR HORA"
        label.textColor = UIColor.contrastColor
        return label
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 67, height: 84)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.indentifier)
        return collectionView
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.contrastColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "PRÓXIMOS DIAS"
        label.textColor = UIColor.contrastColor
        return label
    }()
    
    private lazy var dailyForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        return tableView
    } ()
    

    
    private let service = Service()
    var city = City(lat: LocationDataManager.shared.latitude, lon: LocationDataManager.shared.longitude, name: LocationDataManager.shared.cityName)
    private var forecastResponse: ForecastResponse?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func fetchData(){
        service.fetchData(city: city){[weak self] response in
            self?.forecastResponse = response
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
    }
    
    private func loadData(){
        cityLabel.text = city.name
        
        temperatureLabel.text = forecastResponse?.current.temp.toCelsius()
        humidityValueLabel.text = "\(forecastResponse?.current.humidity ?? 0) %"
        windValueLabel.text = "\(forecastResponse?.current.windSpeed ?? 0) KM/H"
        weatherIcon.image = UIImage(named: "\(forecastResponse?.current.weather[0].icon ?? "")")
        if forecastResponse?.current.weather[0].icon.last != "n" {
            backgroundView.image = UIImage(named: "backgroundDay")
        } else {
            backgroundView.image = UIImage(named: "backgroundNight")
        }

        
        hourlyCollectionView.reloadData()
        dailyForecastTableView.reloadData()
        print(loadAndPrintStateKeys(from: "brazilianCities"))
    }

    private func setupView(){
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        view.addSubview(backgroundView)
        view.addSubview(headerView)
        view.addSubview(statsStackView)
        view.addSubview(hourlyForecastLabel)
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyForecastLabel)
        view.addSubview(dailyForecastTableView)

        headerView.addSubview(cityStackView)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(weatherIcon)



    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo:  view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            switchLocationButton.heightAnchor.constraint(equalToConstant: 25),
            switchLocationButton.widthAnchor.constraint(equalToConstant: 50),
            cityStackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 30),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 71),
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            weatherIcon.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 8)
            
        ])
        
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            statsStackView.widthAnchor.constraint(equalToConstant: 206),
            statsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 70),
            hourlyForecastLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            hourlyForecastLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 22),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 84),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ])
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 29),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            dailyForecastTableView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 15),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    @objc private func showStates() {
        // Call the working function that returns the array of states
        let states = loadAndPrintStateKeys(from: "brazilianCities")
        
        // Initialize the StringTableViewController and pass the states
        let stringVC = StringTableViewController()
        stringVC.data = states
        stringVC.modalPresentationStyle = .pageSheet
        self.present(stringVC, animated: true)
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastResponse?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.indentifier, for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let forecast = forecastResponse?.hourly[indexPath.row
        ]
        cell.loadData(time: forecast?.dt.toHourFormat(), icon: UIImage(named: "\(forecast?.weather[0].icon ?? "")"), temp: forecast?.temp.toCelsius())
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  forecastResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        
        let forecast = forecastResponse?.daily[indexPath.row]
        cell.loadData(weekDay: forecast?.dt.toWeekdayName(), min: forecast?.temp.min.toCelsius(), max: forecast?.temp.max.toCelsius(), icon: UIImage(named: "\(forecast?.weather[0].icon ?? "")"))
        return cell
    }
    
    
}

