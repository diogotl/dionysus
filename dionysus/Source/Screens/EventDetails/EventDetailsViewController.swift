//
//  EventDetailsViewController.swift
//  dionysus
//
//  Created by Diogo on 09/08/2025.
//

import Foundation
import UIKit

class EventDetailsViewController: UIViewController {
    
    let contentView: EventDetailsView
    let viewModel: EventDetailsViewModel
    
    init(
        contentView: EventDetailsView,
        viewModel: EventDetailsViewModel
    ){
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = contentView
        
        viewModel.onDetailsLoaded = { [weak self] eventDetails in
            print("Dados recebidos:", eventDetails)
            self?.contentView.title.text = eventDetails.title
        }
        viewModel.fetchDetails(
            completion: { result in
                switch result {
                case .success(let data):
                    print("Dados recebidos:", data)
                case .failure(let error):
                    print("Erro ao buscar detalhes do evento:", error)
                }
            }
        )

    }
}

