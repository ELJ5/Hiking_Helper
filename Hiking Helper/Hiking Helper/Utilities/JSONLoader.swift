import Foundation

class JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("❌ Could not find \(filename).json in bundle")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("❌ Could not load data from \(filename).json")
            return nil
        }
        
        let decoder = JSONDecoder()
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Missing key: '\(key.stringValue)'")
            print("   Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type mismatch: expected \(type)")
            print("   Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            print("   \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            print("❌ Missing value for type: \(type)")
            print("   Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch let DecodingError.dataCorrupted(context) {
            print("❌ Data corrupted")
            print("   \(context.debugDescription)")
        } catch {
            print("❌ Decoding error: \(error)")
        }
        
        return nil
    }
}
