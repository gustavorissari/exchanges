import UIKit

final class ExchangeListView: UIView {
  
  // MARK: - Callbacks
  var onRefreshPulled: (() -> Void)?
  
  // MARK: - UI Components
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .systemBackground
    tableView.register(ExchangeViewCell.self, forCellReuseIdentifier: ExchangeViewCell.identifier)
    
    return tableView
  }()
  
  private let refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.tintColor = .systemGray
    return refresh
  }()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) { nil }
  
  func isRefreshing() -> Bool {
    refreshControl.isRefreshing
  }
  
  func stopLoading() {
    refreshControl.endRefreshing()
  }
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
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
  }
  
  @objc private func handleRefresh() {
      onRefreshPulled?()
  }
}
