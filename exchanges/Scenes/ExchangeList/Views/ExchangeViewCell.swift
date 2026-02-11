import UIKit
import Kingfisher

final class ExchangeViewCell: UITableViewCell {
  
  static let identifier = "ExchangeViewCell"
  
  // MARK: - UI Components
  private let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .systemGray6
    iv.layer.cornerRadius = 8
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private let contentStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 2
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .label
    return label
  }()
  
  private let volumeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .medium)
    label.textColor = .systemGreen
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 11, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) { nil }
  
  // MARK: - Prepare For Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.kf.cancelDownloadTask()
    
    iconImageView.image = nil
    titleLabel.text = nil
    volumeLabel.text = nil
    dateLabel.text = nil
    
    volumeLabel.isHidden = false
    dateLabel.isHidden = false
  }
  
  // MARK: - Configuration
  func configure(with model: ExchangeInfoModel) {
    titleLabel.text = model.name
    
    if let volume = model.spotVolumeUsd {
      volumeLabel.text = volume.toCurrency()
      volumeLabel.isHidden = false
    } else {
      volumeLabel.isHidden = true
    }
    
    if let date = model.dateLaunched {
      dateLabel.text = "Lançada em: \(date.toDisplayDate())"
      dateLabel.isHidden = false
    } else {
      dateLabel.isHidden = true
    }
    
    if let logo = model.logo, let url = URL(string: logo) {
      iconImageView.kf.setImage(
        with: url,
        placeholder: UIImage(systemName: "bitcoinsign.circle.fill"),
        options: [.transition(.fade(0.2))]
      )
    }
  }
  
  // MARK: - Setup
  private func setupView() {
    contentView.addSubview(iconImageView)
    contentView.addSubview(contentStack)
    
    contentStack.addArrangedSubview(titleLabel)
    contentStack.addArrangedSubview(volumeLabel)
    contentStack.addArrangedSubview(dateLabel)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      iconImageView.widthAnchor.constraint(equalToConstant: 44),
      iconImageView.heightAnchor.constraint(equalToConstant: 44),
      
      contentStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      contentStack.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
      contentStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
    ])
  }
}
