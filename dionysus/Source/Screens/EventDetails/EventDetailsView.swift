//
//  EventDetailsView.swift
//  dionysus
//
//  Created by Diogo on 09/08/2025.
//

import Foundation
import UIKit

class EventDetailsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = .cyan
    }
}

