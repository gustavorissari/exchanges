import UIKit

final class ExchangeListViewController: UIViewController {
  
  private let viewModel: ExchangeListViewModel
  private let contentView = ExchangeListView()
  
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
    bindViewModel()
    
    viewModel.fetchExchanges()
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
  }
}

// MARK: - UITableViewDataSource & Delegate
extension ExchangeListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath)
    let exchange = viewModel.exchange(at: indexPath.row)
    
    var content = cell.defaultContentConfiguration()
    content.text = exchange.name
    content.secondaryText = viewModel.getFormattedVolume(for: indexPath.row)
    cell.contentConfiguration = content
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.didSelectExchange(at: indexPath.row)
  }
}
