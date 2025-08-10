//
//  EventsListViewController.swift
//  dionysus
//
//  Created by Diogo on 07/08/2025.
//

import Foundation
import UIKit

class EventsListViewController: UIViewController {
    
    let contentView: EventsListView
    let viewModel: EventsListViewModel
    
    weak var coordinator: EventsListViewFlowDelegate?
    
    init(
        contentView: EventsListView,
        viewModel: EventsListViewModel,
        coordinator: EventsListViewFlowDelegate?
    ) {
            self.contentView = contentView
            self.viewModel = viewModel
            self.coordinator = coordinator
            
            super.init(nibName: nil, bundle: nil)
            setup()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view = contentView
        
        viewModel.onEventsUpdated = { [weak self] events in
            self?.contentView.tableView.reloadData()
        }
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            if self?.view.window != nil {
                self?.present(alert, animated: true)
            }
        }

        viewModel.onLoading = { isLoading in
            print("Loading: \(isLoading)")
        }
        
        viewModel.fetchEvents()
        
        super.viewDidLoad()
    }
    
    private func setup() {
        self.contentView.tableView.delegate = self
        self.contentView.tableView.dataSource = self
        self.contentView.tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        
        
    }
    
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        let event = viewModel.events[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    
    //didSelectRowAt method to handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedEvent = viewModel.events[indexPath.row]
        print("Selected event: \(selectedEvent.title)")
        coordinator?.goToEventDetails(eventId: selectedEvent.id)
    }
}
