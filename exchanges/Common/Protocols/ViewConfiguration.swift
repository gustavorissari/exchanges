import Foundation

protocol ViewConfiguration {
  func buildHierarchy()
  func setupConstraints()
  func configureViews()
  func setupView()
}

extension ViewConfiguration {
  func setupView() {
    buildHierarchy()
    setupConstraints()
    configureViews()
  }
  
  func configureViews() {}
}
