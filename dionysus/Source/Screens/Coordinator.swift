//
//  Coordinator.swift
//  dionysus
//
//  Created by Diogo on 09/08/2025.
//

//
//  ReminderFlowController.swift
//  Reminder
//
//  Created by Arthur Rios on 18/10/24.
//

import Foundation
import UIKit

class Coordinator {
    // MARK: - Properties
    private var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    
    // MARK: - init
    public init() {
        self.viewControllerFactory = ViewControllersFactory()
    }

    // MARK: - startFlow
    func start() -> UINavigationController? {
        let startViewController = viewControllerFactory.makeEventsListController(
            coordinator: self
        )
        self.navigationController = UINavigationController(rootViewController: startViewController)
        return navigationController
    }
}

extension Coordinator: EventsListViewFlowDelegate {
    func goToEventDetails(eventId: UUID) {
        let eventDetailsController = viewControllerFactory.makeEventsDetailsController(eventId: eventId)
        
        navigationController?.pushViewController(eventDetailsController, animated: true)    
    }
}
