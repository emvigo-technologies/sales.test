import Foundation

// MARK: - VMCRoomsModelElement
struct VMCRoomsModelElement: Codable {
    let createdAt: String?
    let isOccupied: Bool?
    let maxOccupancy: Int?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case isOccupied = "isOccupied"
        case maxOccupancy = "maxOccupancy"
        case id = "id"
    }
}

// MARK: VMCRoomsModelElement convenience initializers and mutators
extension VMCRoomsModelElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VMCRoomsModelElement.self, from: data)
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
        isOccupied: Bool?? = nil,
        maxOccupancy: Int?? = nil,
        id: String?? = nil
    ) -> VMCRoomsModelElement {
        return VMCRoomsModelElement(
            createdAt: createdAt ?? self.createdAt,
            isOccupied: isOccupied ?? self.isOccupied,
            maxOccupancy: maxOccupancy ?? self.maxOccupancy,
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

typealias VMCRoomsModel = [VMCRoomsModelElement]

extension Array where Element == VMCRoomsModel.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VMCRoomsModel.self, from: data)
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
