//
//  ViewController.swift
//  dionysus
//
//  Created by Diogo on 07/08/2025.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false

    }
}
