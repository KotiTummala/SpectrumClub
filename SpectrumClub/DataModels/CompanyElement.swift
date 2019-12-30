// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let companyElement = try CompanyElement(json)

import Foundation

// MARK: - CompanyElement
struct CompanyElement: Codable {
    let id, company, website: String?
    let logo: String?
    let about: String?
    var isFavorite: Bool = false
    var isFollowing: Bool = false
    let members: [Member]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case company, website, logo, about, members
    }
}

// MARK: CompanyElement convenience initializers and mutators

extension CompanyElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CompanyElement.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        company: String?? = nil,
        website: String?? = nil,
        logo: String?? = nil,
        about: String?? = nil,
        members: [Member]?? = nil
    ) -> CompanyElement {
        return CompanyElement(
            id: id ?? self.id,
            company: company ?? self.company,
            website: website ?? self.website,
            logo: logo ?? self.logo,
            about: about ?? self.about,
            members: members ?? self.members
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

