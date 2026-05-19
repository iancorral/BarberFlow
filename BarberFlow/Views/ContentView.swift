import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Reservar", systemImage: "scissors")
            }

            NavigationStack {
                AppointmentsView()
            }
            .tabItem {
                Label("Mis citas", systemImage: "calendar.badge.clock")
            }
        }
        .tint(Color.brandWood)
    }
}
