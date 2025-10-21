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
        contentView.backgroundColor = .black
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view = contentView
        
        // Título e menu de navegação (pull‑down menu com visual “glass” nativo)
        navigationItem.title = "Eventos"
        setupNavigationMenu()
        
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
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Pull‑Down Menu na Navigation Bar
    private func setupNavigationMenu() {
        // Ações do menu
        let refreshAction = UIAction(title: "Atualizar", image: UIImage(systemName: "arrow.clockwise")) { [weak self] _ in
            self?.viewModel.fetchEvents()
        }
        
        let aboutAction = UIAction(title: "Sobre", image: UIImage(systemName: "info.circle")) { [weak self] _ in
            let alert = UIAlertController(
                title: "Sobre",
                message: "Menu flutuante nativo com visual de vidro do iOS (UIMenu/UIAction).",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        // Você pode criar submenus também, por exemplo, um submenu de ordenação:
        let sortByTitle = UIAction(title: "Título", image: UIImage(systemName: "textformat")) { [weak self] _ in
            guard let self else { return }
            self.viewModel.events.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            self.contentView.tableView.reloadData()
        }
        let sortByDate = UIAction(title: "Data", image: UIImage(systemName: "calendar")) { [weak self] _ in
            guard let self else { return }
            self.viewModel.events.sort {
                switch ($0.date, $1.date) {
                case let (d0?, d1?): return d0 < d1
                case (nil, _?): return false
                case (_?, nil): return true
                default: return false
                }
            }
            self.contentView.tableView.reloadData()
        }
        let sortMenu = UIMenu(title: "Ordenar por", options: .displayInline, children: [sortByTitle, sortByDate])
        
        let topMenu = UIMenu(title: "", children: [refreshAction, sortMenu, aboutAction])
        
        // Botão que mostra o menu
        let menuButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: topMenu
        )
        navigationItem.rightBarButtonItem = menuButton
    }
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    // didSelectRowAt: navega para detalhes
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEvent = viewModel.events[indexPath.row]
        print("Selected event: \(selectedEvent.title)")
        coordinator?.goToEventDetails(eventId: selectedEvent.id)
    }
    
    // MARK: - Context Menu (toque e segure) com visual “glass” nativo
    // iOS 13+
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let event = viewModel.events[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return nil }
            let details = UIAction(title: "Ver detalhes", image: UIImage(systemName: "chevron.right.circle")) { _ in
                self.coordinator?.goToEventDetails(eventId: event.id)
            }
            let copyTitle = UIAction(title: "Copiar título", image: UIImage(systemName: "doc.on.doc")) { _ in
                UIPasteboard.general.string = event.title
            }
            let share = UIAction(title: "Compartilhar", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                let items: [Any] = [event.title, event.details ?? ""]
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(vc, animated: true)
            }
            return UIMenu(title: "", children: [details, copyTitle, share])
        }
    }
}

