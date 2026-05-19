import Foundation
import Combine

enum AuthState {
    case unauthenticated
    case authenticated(AuthUser)
    case loading
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .unauthenticated
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let service = AuthService.shared
    private let keychain = KeychainService.shared

    func checkSession() async {
        guard keychain.refreshToken != nil else {
            state = .unauthenticated
            return
        }
        do {
            let me = try await service.fetchMe()
            state = .authenticated(AuthUser(id: me.id, email: me.email, nombre: me.nombre))
        } catch {
            keychain.clearAll()
            state = .unauthenticated
        }
    }

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        // --- MOCK temporal, borra esto cuando tengas el backend ---
        try? await Task.sleep(nanoseconds: 800_000_000) // simula delay de red
        if email == "test@test.com" && password == "1234" {
            state = .authenticated(AuthUser(id: 1, email: email, nombre: "Miguel"))
        } else {
            errorMessage = "Credenciales incorrectas."
        }
        // ----------------------------------------------------------

        isLoading = false
    }

    func logout() {
        keychain.clearAll()
        state = .unauthenticated
    }
}
