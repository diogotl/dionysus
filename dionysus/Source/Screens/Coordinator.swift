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
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    // Tab bar e navs por aba
    private var tabBarController: UITabBarController?
    private var eventsNavigationController: UINavigationController?
    
    // MARK: - init
    public init() {
        self.viewControllerFactory = ViewControllersFactory()
    }

    // MARK: - startFlow
    func start() -> UITabBarController? {
        // Aba 1: Eventos
        let eventsListVC = viewControllerFactory.makeEventsListController(coordinator: self)
        eventsListVC.title = "Eventos"
        let eventsNav = UINavigationController(rootViewController: eventsListVC)
        eventsNav.tabBarItem = UITabBarItem(title: "Eventos",
                                            image: UIImage(systemName: "list.bullet"),
                                            selectedImage: UIImage(systemName: "list.bullet"))
        self.eventsNavigationController = eventsNav
        
        // Aba 2: Configurações (placeholder)
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .systemBackground
        settingsVC.title = "Configurações"
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Configurações",
                                              image: UIImage(systemName: "gearshape"),
                                              selectedImage: UIImage(systemName: "gearshape.fill"))
        
        // Cria o Tab Bar como root
        let tabBar = UITabBarController()
        tabBar.viewControllers = [eventsNav, settingsNav]
        self.tabBarController = tabBar
        
        return tabBar
    }
}

extension Coordinator: EventsListViewFlowDelegate {
    func goToEventDetails(eventId: UUID) {
        let eventDetailsController = viewControllerFactory.makeEventsDetailsController(eventId: eventId)
        
        if let eventsNav = eventsNavigationController {
            // Empurra nos detalhes da aba de Eventos
            eventsNav.pushViewController(eventDetailsController, animated: true)
        } else if let selectedNav = tabBarController?.selectedViewController as? UINavigationController {
            // Fallback: empurra na aba selecionada
            selectedNav.pushViewController(eventDetailsController, animated: true)
        }
    }
}

