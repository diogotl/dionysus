//
//  ViewControllersFactoryProtocol.swift
//  dionysus
//
//  Created by Diogo on 09/08/2025.
//

import Foundation

protocol ViewControllersFactoryProtocol: AnyObject {
    func makeEventsListController(coordinator:EventsListViewFlowDelegate) -> EventsListViewController
    func makeEventsDetailsController(eventId: UUID) -> EventDetailsViewController
}
