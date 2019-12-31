// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let member = try Member(json)

import Foundation

// MARK: - Member
class Member: Codable {
    let id: String?
    let age: Int?
    let name: Name?
    let email, phone: String?
    
    var isFavorite = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case age, name, email, phone
    }

    init(id: String?, age: Int?, name: Name?, email: String?, phone: String?) {
        self.id = id
        self.age = age
        self.name = name
        self.email = email
        self.phone = phone
    }
}

// MARK: Member convenience initializers and mutators

extension Member {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Member.self, from: data)
        self.init(id: me.id, age: me.age, name: me.name, email: me.email, phone: me.phone)
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

    func with(
        id: String?? = nil,
        age: Int?? = nil,
        name: Name?? = nil,
        email: String?? = nil,
        phone: String?? = nil
    ) -> Member {
        return Member(
            id: id ?? self.id,
            age: age ?? self.age,
            name: name ?? self.name,
            email: email ?? self.email,
            phone: phone ?? self.phone
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
