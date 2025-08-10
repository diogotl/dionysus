//
//  ViewControllersFactory.swift
//  dionysus
//
//  Created by Diogo on 09/08/2025.
//

import Foundation
import UIKit

final class ViewControllersFactory: ViewControllersFactoryProtocol {
    
    func makeEventsListController(coordinator:EventsListViewFlowDelegate) -> EventsListViewController {
        let contentView = EventsListView()
        let viewModel = EventsListViewModel()
        let controller = EventsListViewController(
            contentView: contentView ,
            viewModel: viewModel,
            coordinator: coordinator
        )
        
        return controller
    }
    
    func makeEventsDetailsController(eventId: UUID) -> EventDetailsViewController {
        let contentView = EventDetailsView()
        let viewModel = EventDetailsViewModel(eventId: eventId)
        let controller = EventDetailsViewController(
            contentView: contentView,
            viewModel: viewModel
        )
        
        return controller
    }
}

