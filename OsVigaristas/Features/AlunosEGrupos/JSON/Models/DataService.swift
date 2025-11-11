//
//  DataService.swift
//  OsVigaristas
//
//  Created by Gabriel Amaral on 11/11/25.
//

import Foundation

class DataService {
    static func load<T: Decodable>(_ filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Arquivo \(filename).json não encontrado.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Não foi possível ler \(filename).json")
        }
        
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Erro ao decodificar \(filename).json")
        }
        
        return decoded
    }
}
