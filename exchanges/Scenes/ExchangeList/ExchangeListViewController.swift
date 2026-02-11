import UIKit

final class ExchangeListViewController: UIViewController {
  
  private let viewModel: ExchangeListViewModel
  private let contentView = ExchangeListView()
  
  // MARK: - UI Components
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .systemGray
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  // MARK: - Init
  init(viewModel: ExchangeListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { nil }
  
  // MARK: - Lifecycle
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigation()
    setupTableView()
    setupLoadingIndicator()
    setupConstraints()
    bindViewModel()
    
    viewModel.fetchExchangesMap()
  }
  
  private func setupNavigation() {
    title = "Exchanges"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupTableView() {
    contentView.tableView.dataSource = self
    contentView.tableView.delegate = self
  }
  
  private func bindViewModel() {
    viewModel.onDataUpdated = { [weak self] in
      DispatchQueue.main.async {
        self?.contentView.tableView.reloadData()
      }
    }
    
    viewModel.onLoadingStatusChanged = { [weak self] isLoading in
      DispatchQueue.main.async {
        if isLoading {
          self?.loadingIndicator.startAnimating()
        } else {
          self?.loadingIndicator.stopAnimating()
        }
      }
    }
  }
  
  private func setupLoadingIndicator() {
    view.addSubview(loadingIndicator)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}

// MARK: - UITableViewDataSource & Delegate
extension ExchangeListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ExchangeViewCell.identifier,
      for: indexPath
    ) as? ExchangeViewCell else {
      return UITableViewCell()
    }
    
    if let exchangeSummary = viewModel.getExchangeInfo(at: indexPath.row) {
      cell.configure(with: exchangeSummary)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.didSelectExchange(at: indexPath.row)
  }
}
