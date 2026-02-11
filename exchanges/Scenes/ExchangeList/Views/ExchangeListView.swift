import UIKit

final class ExchangeListView: UIView {
  
  // MARK: - UI Components
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemBackground
    tableView.register(ExchangeViewCell.self, forCellReuseIdentifier: ExchangeViewCell.identifier)
    
    return tableView
  }()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) { nil }
}

// MARK: - ViewConfiguration
extension ExchangeListView: ViewConfiguration {
  func buildHierarchy() {
    addSubview(tableView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func configureViews() {
    backgroundColor = .systemBackground
  }
}
