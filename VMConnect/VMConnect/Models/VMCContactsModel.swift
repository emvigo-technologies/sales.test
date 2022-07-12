import Foundation

// MARK: - VMCContactModelElement
struct VMCContactModelElement: Codable {
    let createdAt: String?
    let firstName: String?
    let avatar: String?
    let lastName: String?
    let email: String?
    let jobtitle: String?
    let favouriteColor: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case avatar = "avatar"
        case lastName = "lastName"
        case email = "email"
        case jobtitle = "jobtitle"
        case favouriteColor = "favouriteColor"
        case id = "id"
    }
}

// MARK: VMCContactModelElement convenience initializers and mutators

extension VMCContactModelElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VMCContactModelElement.self, from: data)
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
        createdAt: String?? = nil,
        firstName: String?? = nil,
        avatar: String?? = nil,
        lastName: String?? = nil,
        email: String?? = nil,
        jobtitle: String?? = nil,
        favouriteColor: String?? = nil,
        id: String?? = nil
    ) -> VMCContactModelElement {
        return VMCContactModelElement(
            createdAt: createdAt ?? self.createdAt,
            firstName: firstName ?? self.firstName,
            avatar: avatar ?? self.avatar,
            lastName: lastName ?? self.lastName,
            email: email ?? self.email,
            jobtitle: jobtitle ?? self.jobtitle,
            favouriteColor: favouriteColor ?? self.favouriteColor,
            id: id ?? self.id
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

typealias VMCContactModel = [VMCContactModelElement]

extension Array where Element == VMCContactModel.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VMCContactModel.self, from: data)
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

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
