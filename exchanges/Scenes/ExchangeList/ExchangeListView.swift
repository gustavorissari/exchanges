import UIKit

final class ExchangeListView: UIView {
  
  // MARK: - UI Components
  lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.backgroundColor = .systemBackground
    table.register(UITableViewCell.self, forCellReuseIdentifier: "ExchangeCell")
    return table
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
