import UIKit
import Kingfisher

final class ExchangeViewCell: UITableViewCell {
  
  static let identifier = "ExchangeViewCell"
  
  // MARK: - UI Components
  private let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .systemGray6
    iv.layer.cornerRadius = 20
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private let contentStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.textColor = .label
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  func configure(with model: ExchangeInfoModel) {
    titleLabel.text = model.name
    subtitleLabel.text = "TESTE"
    
    if let logo = model.logo {
      guard let url = URL(string: logo) else { return }
      
      iconImageView.kf.indicatorType = .activity
      iconImageView.kf.setImage(
        with: url,
        placeholder: UIImage(systemName: "bitcoinsign.circle.fill"),
        options: [.transition(.fade(0.3)), .cacheOriginalImage]
      )
    }
  }
  
  // MARK: - Prepare For Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    iconImageView.kf.cancelDownloadTask()
    iconImageView.image = nil
  }
  
  // MARK: - Setup
  private func setupView() {
    accessoryType = .disclosureIndicator
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(contentStack)
    
    contentStack.addArrangedSubview(titleLabel)
    contentStack.addArrangedSubview(subtitleLabel)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 40),
      iconImageView.heightAnchor.constraint(equalToConstant: 40),
      
      contentStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      contentStack.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
      contentStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
      contentStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
    ])
  }
}
