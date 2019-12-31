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

extension Member {
    func nameCompare(e2: Member) -> ComparisonResult {
        guard let firstName = name?.description, let secondName = e2.name?.description else {
            return .orderedAscending
        }
        return firstName.compare(secondName)
    }
    
    func ageCompare(e2: Member) -> ComparisonResult {
        guard let firstAge = age, let secondAge = e2.age else {
            return .orderedAscending
        }
        return firstAge > secondAge ? .orderedAscending : .orderedDescending
    }
}
extension ComparisonResult {
    func flip() -> ComparisonResult {
        switch self {
        case .orderedAscending:
            return .orderedDescending
        case .orderedDescending:
            return .orderedAscending
        default:
            return .orderedSame
        }
    }
}

infix operator <<<
func <<< <A, B, C>(f: @escaping (B) -> () -> C, g: @escaping (A) -> (A) -> B) -> (A) -> (A) -> C {
    return { x in { y in f(g(x)(y))() } }
}
extension Sequence {
    typealias AttributeCompare = (Iterator.Element) -> (Iterator.Element) -> ComparisonResult
    
    func sorted(by comparisons: AttributeCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1)(e2)
                guard comparisonResult == .orderedSame
                    else {
                        return comparisonResult == .orderedAscending
                }
            }
            return false
        }
    }
}
