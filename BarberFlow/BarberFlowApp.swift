import SwiftUI

@main
struct BarberFlowApp: App {
    @StateObject private var appointmentsVM = AppointmentsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appointmentsVM)
        }
    }
}
