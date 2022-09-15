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
    private var selectedPersonCount = 0
    private let selectedLocaton: Location
    var locationsDidAssign : (([Person]) -> Void)?
    let loadPersons: ((@escaping (Result<[Person], Error>) -> Void) -> Void)
    var onChange: ((State) -> Void)?
    var isAnyPersonSelected: ((Bool) -> Void)?
   
    
    var numberOfItems: Int {
        persons.count
    }
    
    
    init(selectedLocation: Location, loadPersons: @escaping ((@escaping (Result<[Person], Error>) -> Void) -> Void)) {
        self.loadPersons = loadPersons
        self.selectedLocaton = selectedLocation
    }
    
    
    func viewDidLoad() {
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func viewDidAppear() {
        getPersons()
    }
    
    func refrsh() {
        getPersons()
    }
    
    private func getPersons() {
        onChange?(.loading)
        loadPersons { [weak self] result in
            DispatchQueue.main.async {
                if let persons = try? result.get() {
                    self?.persons = persons
                    self?.onChange?(.loaded)
                } else {
                    self?.onChange?(.failed)
                }
            }
        }
    }
    
    func titleForIndex(index: Int) -> String {
        persons.map {
            $0.firstName + " " + $0.lastName
        }[index]
    }
    
    func select(at index: Int) {
        selectedPersonCount += 1
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func deselect(at index: Int) {
        selectedPersonCount -= 1
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func locationAssigned(to indexes: [Int]) {
        let selectedPersons = indexes.forEach { index in
            persons[index].addLocation(selectedLocaton)
        }
                                                                    
        locationsDidAssign?(persons)
    }
    
}

final class AssignLocationViewController: UITableViewController {
    private let viewModel: AssignLocationViewModel
    var onAddButtonTap : (() -> Void)?

    private lazy var assignButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Assign", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button =  UIButton(type: .system)
        button.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate).withTintColor(.systemBlue), for: .normal)
        return button
    }()
    
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
        tableView.allowsMultipleSelection = true
        bind()
        viewModel.viewDidLoad()
        setupButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    private func setupButton() {
        self.view.addSubview(assignButton)
        assignButton.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 24, right: 16) )
        assignButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        assignButton.layer.cornerRadius = 4
        assignButton.clipsToBounds = true
        assignButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        assignButton.layer.borderWidth = 0.8
        let constrinat = assignButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        constrinat.priority = .defaultHigh
        constrinat.isActive = true
        assignButton.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        self.view.addSubview(addButton)
        addButton.anchor(bottom: self.assignButton.topAnchor, trailing: self.view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 50, height: 50))
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
        
        viewModel.isAnyPersonSelected = { [weak self] isSelected in
            self?.assignButton.isEnabled = isSelected
        }
        
      
    }
    
    @objc
    private func addButtonTapped() {
        onAddButtonTap?()
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
        viewModel.select(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .none
        viewModel.deselect(at: indexPath.row)
    }
    
    
    
    @objc
    private func assignButtonTapped() {
        let selectedIndexes = tableView.indexPathsForSelectedRows?.map(\.row) ?? []
        viewModel.locationAssigned(to: selectedIndexes)
        
    }
    
    func refresh() {
        viewModel.refrsh()
    }
        
}
