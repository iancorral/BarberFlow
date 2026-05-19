import Foundation

enum AuthError: LocalizedError {
    case invalidURL
    case serverError(String)
    case decodingError
    case unauthorized
    case tokenExpired

    var errorDescription: String? {
        switch self {
        case .invalidURL:        return "URL inválida."
        case .serverError(let m): return m
        case .decodingError:     return "Error procesando la respuesta."
        case .unauthorized:      return "Sesión expirada. Inicia sesión de nuevo."
        case .tokenExpired:      return "Token expirado."
        }
    }
}

final class AuthService {
    static let shared = AuthService()
    private init() {}

    // ← Cambia esta base URL por la tuya
    private let base = "https://tu-api.com"

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        return d
    }()

    // MARK: - Login
    func login(email: String, password: String) async throws -> LoginResponse {
        let url = try makeURL("/api/auth/login/")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(LoginRequest(email: email, password: password))

        let (data, response) = try await URLSession.shared.data(for: req)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        if status == 200 {
            return try decodeSafe(LoginResponse.self, from: data)
        } else {
            let err = try? decoder.decode(APIErrorResponse.self, from: data)
            throw AuthError.serverError(err?.message ?? "Error al iniciar sesión.")
        }
    }

    // MARK: - Refresh
    func refreshAccessToken() async throws -> String {
        guard let refresh = KeychainService.shared.refreshToken else {
            throw AuthError.unauthorized
        }
        let url = try makeURL("/api/auth/refresh/")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(RefreshRequest(refresh: refresh))

        let (data, response) = try await URLSession.shared.data(for: req)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        if status == 200 {
            let result = try decodeSafe(RefreshResponse.self, from: data)
            KeychainService.shared.accessToken = result.access
            return result.access
        } else if status == 401 {
            throw AuthError.tokenExpired
        } else {
            let err = try? decoder.decode(APIErrorResponse.self, from: data)
            throw AuthError.serverError(err?.message ?? "Error renovando sesión.")
        }
    }

    // MARK: - Me
    func fetchMe() async throws -> MeResponse {
        let token = try await validAccessToken()
        let url = try makeURL("/api/auth/me/")
        var req = URLRequest(url: url)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: req)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0

        if status == 200 {
            return try decodeSafe(MeResponse.self, from: data)
        } else if status == 401 {
            throw AuthError.unauthorized
        } else {
            throw AuthError.decodingError
        }
    }

    // MARK: - Helpers

    // Devuelve el access token vigente; si falla, renueva automáticamente
    func validAccessToken() async throws -> String {
        if let token = KeychainService.shared.accessToken { return token }
        return try await refreshAccessToken()
    }

    private func makeURL(_ path: String) throws -> URL {
        guard let url = URL(string: base + path) else { throw AuthError.invalidURL }
        return url
    }

    private func decodeSafe<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw AuthError.decodingError
        }
    }
}
