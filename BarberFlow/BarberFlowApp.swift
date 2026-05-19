import SwiftUI

@main
struct BarberiaFlowApp: App {
    @StateObject private var authVM         = AuthViewModel()
    @StateObject private var appointmentsVM = AppointmentsViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch authVM.state {
                case .unauthenticated, .loading:
                    LoginView()
                        .environmentObject(authVM)
                case .authenticated:
                    ContentView()
                        .environmentObject(authVM)
                        .environmentObject(appointmentsVM)
                }
            }
            .tint(Color.brandWood)
            .task { await authVM.checkSession() }
        }
    }
}
