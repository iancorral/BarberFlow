import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let access: String
    let refresh: String
    let user: AuthUser
}

struct AuthUser: Decodable {
    let id: Int
    let email: String
    let nombre: String
}

struct MeResponse: Decodable {
    let id: Int
    let email: String
    let nombre: String
    let username: String
}

struct RefreshRequest: Encodable {
    let refresh: String
}

struct RefreshResponse: Decodable {
    let access: String
}

struct APIErrorResponse: Decodable {
    let nonFieldErrors: [String]?
    let error: String?
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case nonFieldErrors = "non_field_errors"
        case error, detail
    }

    var message: String {
        nonFieldErrors?.first ?? error ?? detail ?? "Error desconocido."
    }
}
