//
//  EventDetailsViewModel.swift
//  dionysus
//
//  Created by Diogo on 10/08/2025.
//

import Foundation

struct EventDetails: Codable {
    let id: UUID
    let title: String
    let details: String
    let slug: String
    let date: String
    let maxAttendees: Int
    let attendeesCount: Int
}

class EventDetailsViewModel {
    
    let eventId: UUID
    
    var onDetailsLoaded: ((EventDetails) -> Void)?
    
    init(eventId: UUID) {
        self.eventId = eventId
    }
    
    func fetchDetails(completion: @escaping (Result<EventDetails, Error>) -> Void) {
        guard let url = URL(string: "https://api-exam-pdm-v2.up.railway.app/events/" + eventId.uuidString) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            }
            return
        }
        
        print("Fetching details for event ID: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let http = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoHTTPResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta HTTP inválida"])))
                }
                return
            }
            
            print("Status code: \(http.statusCode)")
            
            guard (200...299).contains(http.statusCode) else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<sem corpo>"
                print("Erro HTTP \(http.statusCode). Corpo: \(body)")
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "HTTPError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "Falha ao carregar detalhes (\(http.statusCode))"])))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sem dados"])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                
                // Tenta decodificar direto
                if let direct = try? decoder.decode(EventDetails.self, from: data) {
                    DispatchQueue.main.async {
                        self?.onDetailsLoaded?(direct)
                        completion(.success(direct))
                    }
                    return
                }
                
                // Tenta decodificar embrulhado em { "event": { ... } }
                let envelope = try decoder.decode(EventDetailEnvelope.self, from: data)
                let details = envelope.event
                DispatchQueue.main.async {
                    self?.onDetailsLoaded?(details)
                    completion(.success(details))
                }
            } catch {
                let body = String(data: data, encoding: .utf8) ?? "<corpo inválido>"
                print("Erro ao decodificar detalhes: \(error). Corpo: \(body)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
