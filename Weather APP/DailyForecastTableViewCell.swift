//
//  DailyForecastTableViewCell.swift
//  Weather APP
//
//  Created by victor mont-morency on 09/09/24.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    static let identifier: String = "DailyForecast"
    
    private lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TER"
        label.textColor = UIColor.colorPrimary
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    } ()
    
    private lazy var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.colorPrimary
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "min 25°C"
        return label
    } ()
    
    private lazy var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.colorPrimary
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "max 32°C"
        return label
    } ()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cloudIcon")

        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weekDayLabel,
                                                      iconImageView,
                                                      minTemperatureLabel,
                                                      maxTemperatureLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 15
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .clear
        selectionStyle = .none
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy(){
        contentView.addSubview(stackView)
    }
    
    private func setConstraints(){
        stackView.setConstraintsToParent(contentView)
        NSLayoutConstraint.activate([
            weekDayLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
            iconImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            minTemperatureLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            maxTemperatureLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100)





        ])
    }
}

