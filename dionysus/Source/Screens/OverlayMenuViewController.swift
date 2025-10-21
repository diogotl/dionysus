// OverlayMenuViewController.swift
// dionysus

import UIKit

final class OverlayMenuViewController: UIViewController {
    
    weak var delegate: OverlayMenuDelegate?
    
    private let blurContainer: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        // Ícone “…” que combina com o menu
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .label
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return btn
    }()
    
    override func loadView() {
        // View pequena e transparente para não bloquear toques fora do botão
        view = UIView()
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupMenu()
    }
    
    private func setupUI() {
        view.addSubview(blurContainer)
        blurContainer.contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            blurContainer.topAnchor.constraint(equalTo: view.topAnchor),
            blurContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            button.centerXAnchor.constraint(equalTo: blurContainer.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: blurContainer.centerYAnchor)
        ])
        
        // Deixa o container circular (tamanho final vem das constraints impostas pelo Coordinator)
        view.layoutIfNeeded()
        blurContainer.layer.cornerRadius = 28
    }
    
    private func setupMenu() {
        if #available(iOS 14.0, *) {
            let goList = UIAction(title: "Eventos", image: UIImage(systemName: "list.bullet")) { [weak self] _ in
                self?.delegate?.overlayOpenEventsList()
            }
            let create = UIAction(title: "Criar evento", image: UIImage(systemName: "plus.circle")) { [weak self] _ in
                self?.delegate?.overlayCreateEvent()
            }
            let settings = UIAction(title: "Configurações", image: UIImage(systemName: "gearshape")) { [weak self] _ in
                self?.delegate?.overlayOpenSettings()
            }
            let menu = UIMenu(title: "", children: [goList, create, settings])
            button.menu = menu
            button.showsMenuAsPrimaryAction = true
        } else {
            // Fallback simples para iOS 13: abre um action sheet
            button.addTarget(self, action: #selector(showFallbackMenu), for: .touchUpInside)
        }
    }
    
    @objc private func showFallbackMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Eventos", style: .default, handler: { [weak self] _ in
            self?.delegate?.overlayOpenEventsList()
        }))
        alert.addAction(.init(title: "Criar evento", style: .default, handler: { [weak self] _ in
            self?.delegate?.overlayCreateEvent()
        }))
        alert.addAction(.init(title: "Configurações", style: .default, handler: { [weak self] _ in
            self?.delegate?.overlayOpenSettings()
        }))
        alert.addAction(.init(title: "Cancelar", style: .cancel))
        
        // Tenta apresentar pelo topo da hierarquia (estamos como child do nav)
        if let presenter = parent?.presentedViewController ?? parent {
            presenter.present(alert, animated: true)
        } else {
            present(alert, animated: true)
        }
    }
}

