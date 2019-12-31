// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let name = try Name(json)

import Foundation

// MARK: - Name
class Name: Codable {
    let first, last: String?

    init(first: String?, last: String?) {
        self.first = first
        self.last = last
    }
}

// MARK: Name convenience initializers and mutators

extension Name {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Name.self, from: data)
        self.init(first: me.first, last: me.last)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    var description: String {
        let firstName = first ?? ""
        let lastName = last ?? ""
        return firstName + " " + lastName
    }

    func with(
        first: String?? = nil,
        last: String?? = nil
    ) -> Name {
        return Name(
            first: first ?? self.first,
            last: last ?? self.last
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
