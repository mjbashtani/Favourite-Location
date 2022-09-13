//
//  AssignLocationViewController.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import UIKit

final class AssignLocationViewModel {
    enum State {
        case pending
        case loading
        case failed
        case loaded
    }
    private var persons: [Person] = []
    let loadPersons: ((Result<[Person], Error>) -> Void) -> Void
    var onChange: ((State) -> Void)?
    
    var numberOfItems: Int {
        persons.count
    }
    
    
    init(loadPersons: @escaping ((Result<[Person], Error>) -> Void) -> Void) {
        self.loadPersons = loadPersons
    }
    
    
    func viewDidLoad() {
        getPersons()
    }
    
    private func getPersons() {
        onChange?(.loading)
        loadPersons { [weak self] result in
            if let persons = try? result.get() {
                self?.persons = persons
                
            } else {
                onChange?(.failed)
            }
        }
    }
    
    func titleForIndex(index: Int) -> String {
        persons.map {
            $0.firstName + " " + $0.lastName
        }[index]
    }
    
    
}

final class AssignLocationViewController: UITableViewController {
    private let viewModel: AssignLocationViewModel
    
    init(viewModel: AssignLocationViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        viewModel.viewDidLoad()
        tableView.allowsMultipleSelection = true
        bind()
        
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] state in
            switch state {
            case .pending, .loading:
                self?.view.showIndicator()
            case .failed:
                self?.view.hideIndicator()
                print("failed")
            case .loaded:
                self?.view.hideIndicator()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        var config = UIListContentConfiguration.cell()
        config.text = viewModel.titleForIndex(index: indexPath.row)
        cell.contentConfiguration = config
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
    }
        
}
