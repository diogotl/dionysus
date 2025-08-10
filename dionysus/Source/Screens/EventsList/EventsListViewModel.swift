//
//  EventsListViewModel.swift
//  dionysus
//
//  Created by Diogo on 07/08/2025.
//

import Foundation
import UIKit


struct EventsResponse: Decodable {
    let events: [Event]
    let total: Int
}


class EventsListViewModel {
    
    var events: [Event] = []
    
    var onEventsUpdated: (([Event]) -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    func fetchEvents(){
        onLoading?(true)
        
        guard let url = URL(string: "http://192.168.1.110:3333/events") else {
            onLoading?(false)
            print("URL inválida")
            onError?(NSError(domain: "URL inválida", code: 0))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                
                print("Resposta recebida: \(String(describing: response))")
            
                
                if let error = error {
                    print("Erro ao buscar eventos: \(error.localizedDescription)")

                    self?.onError?(error)
                    return
                }
                
                guard let data = data else {
                    print("Nenhum dado recebido")
                    self?.onError?(NSError(domain: "Sem dados", code: 0))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let resp = try decoder.decode(EventsResponse.self, from: data)

                    print("Eventos recebidos: \(resp)")
                    self?.events = resp.events
                    self?.onEventsUpdated?(resp.events)
                } catch {
                    self?.onError?(error)
                    
                    print("Erro ao decodificar JSON: \(error.localizedDescription)")
                    print("Dados recebidos: \(String(data: data, encoding: .utf8) ?? "Dados inválidos")")
                }

            }
        }
        task.resume()
    }
}

