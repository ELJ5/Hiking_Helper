//
//  JSONLoader.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation

class JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Could not find \(filename).json in bundle")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("❌ Could not load data from \(filename).json")
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            print("Could not decode \(filename).json")
            return nil
        }
        
        return decoded
    }
}
