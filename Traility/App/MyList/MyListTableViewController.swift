//
//  MyListTableViewController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit
import Combine

class MyListTableViewController: UITableViewController {
    weak var coordinator : MyListCoordinator?
    
    private var subscribers = Set<AnyCancellable>()
    private var parks : [ParkViewModel] = []
    private let myListViewModel : MyListViewModel = MyListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupBinding()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myListViewModel.getParks()
        coordinator?.setupNavigationBarVisibility()
    }
}

extension MyListTableViewController {
    private func setup() {
        self.navigationItem.title = "My List"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(MyListTableViewCell.self, forCellReuseIdentifier: MyListTableViewCell.id)
        self.tableView.rowHeight = 85
    }
    
    private func setupBinding() {
        myListViewModel
            .$parks
            .receive(on: RunLoop.main)
            .sink { [weak self] parks in
                guard let self = self else { return}
                DispatchQueue.main.async {
                    self.parks = parks
                    self.tableView.reloadSections([0], with: .fade)
                }
            }
            .store(in: &subscribers)
    }
}

// MARK: - Table view data source
extension MyListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyListTableViewCell.id, for: indexPath) as? MyListTableViewCell else {
            return defaultCell
        }
        cell.configure(for: parks[indexPath.row])
        
        return cell
    }
}

// MARK: - Table view delegate
extension MyListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let park = parks[indexPath.row]
        coordinator?.goToDetail(model: park)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let park = parks[indexPath.row]
            let isDeleted = myListViewModel.deletePark(with: park.id)
            if isDeleted {
                parks.removeAll(where: {$0 == park})
                tableView.deleteRows(at: [indexPath], with: .fade)
                Haptics.shared.play(.light)
            }
        }
    }
}

fileprivate class MyListViewModel {
    @Published private(set) var parks : [ParkViewModel] = []
    
    init() {
        
    }
    
    func getParks() {
        if let parks = CoreDataManager().getAllParks() {
            let parksViewModels : [ParkViewModel] = parks.map { park in
                return ParkViewModel(data: park)
            }
            self.parks = parksViewModels
        }
    }
    
    func deletePark(with id : UUID) -> Bool {
        let success = CoreDataManager().deletePark(id: id)
        return success
    }
}
