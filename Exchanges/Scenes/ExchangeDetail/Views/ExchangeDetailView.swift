import UIKit
import Kingfisher

final class ExchangeDetailView: UIView {
  
  // MARK: - Callbacks
  var onWebsiteTapped: (() -> Void)?
  
  // MARK: - UI Components
  private let scrollView: UIScrollView = {
    let scroollView = UIScrollView()
    scroollView.translatesAutoresizingMaskIntoConstraints = false
    scroollView.showsVerticalScrollIndicator = true
    return scroollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .fill
    stack.distribution = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 12
    imageView.clipsToBounds = true
    imageView.backgroundColor = .systemGray6
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 26, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  private let idLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let feeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    return label
  }()
  
  private let launchDateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  private let websiteLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    label.textColor = .systemBlue
    label.isUserInteractionEnabled = true
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = .label
    label.numberOfLines = 0
    return label
  }()
  
  private let currenciesTitleLabel: UILabel = {
    let label = UILabel()
    label.text = L10n.ExchangeDetail.currenciesTitle
    label.font = .systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  private let currenciesStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 10
    return stack
  }()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupGesture()
  }
  
  required init?(coder: NSCoder) { nil }
  
  private func setupGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleWebsiteTap))
    websiteLabel.addGestureRecognizer(tap)
  }
  
  @objc private func handleWebsiteTap() {
    onWebsiteTapped?()
  }
  
  // MARK: - Public Configuration
  func configure(with viewModel: ExchangeDetailViewModel) {
    nameLabel.text = viewModel.name
    descriptionLabel.text = viewModel.description
    idLabel.text = String(format: L10n.ExchangeDetail.idLabel, viewModel.id)
    feeLabel.text = String(format: L10n.ExchangeDetail.feeLabel, viewModel.makerFee, viewModel.takerFee)
    launchDateLabel.text = String(format: L10n.ExchangeDetail.launchedLabel, viewModel.launchDate)
    websiteLabel.text = viewModel.websiteUrl ?? L10n.EmptyText.empty
    
    if let urlString = viewModel.logoUrl, let url = URL(string: urlString) {
      logoImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "bitcoinsign.circle.fill"))
    }
    
    setupCurrencies(viewModel.currencies)
  }
  
  private func setupCurrencies(_ currencies: [CurrencyModel]) {
    currenciesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    currenciesTitleLabel.isHidden = currencies.isEmpty
    currencies.forEach { currency in
      let row = createCurrencyRow(name: currency.name, price: currency.priceUsd)
      currenciesStackView.addArrangedSubview(row)
    }
  }
  
  private func createCurrencyRow(name: String, price: Double) -> UIView {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .medium)
    label.text = String(format: L10n.ExchangeDetail.currencyRow, name, price.toCurrency())
    label.numberOfLines = 1
    return label
  }
}

// MARK: - ViewConfiguration
extension ExchangeDetailView: ViewConfiguration {
  func buildHierarchy() {
    backgroundColor = .systemBackground
    
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(logoImageView)
    contentView.addSubview(mainStackView)
    
    mainStackView.addArrangedSubview(nameLabel)
    mainStackView.addArrangedSubview(idLabel)
    mainStackView.addArrangedSubview(launchDateLabel)
    mainStackView.addArrangedSubview(feeLabel)
    mainStackView.addArrangedSubview(websiteLabel)
    mainStackView.addArrangedSubview(descriptionLabel)
    
    let separator = UIView()
    separator.backgroundColor = .systemGray5
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    mainStackView.addArrangedSubview(separator)
    
    mainStackView.addArrangedSubview(currenciesTitleLabel)
    mainStackView.addArrangedSubview(currenciesStackView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
      logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 100),
      logoImageView.widthAnchor.constraint(equalToConstant: 100),
      
      mainStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
    ])
  }
}
