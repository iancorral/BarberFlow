import SwiftUI

struct BarberDetailView: View {
    let barber: Barber
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Avatar
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.secondary)
                    }
                
                VStack(spacing: 4) {
                    Text(barber.name)
                        .font(.title2.bold())
                    Text(barber.specialty)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text(String(format: "%.1f", barber.rating)).bold()
                    }
                    .font(.subheadline)
                }
                
                Divider()
                
                // Servicios
                VStack(alignment: .leading, spacing: 12) {
                    Text("Servicios")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(SampleData.services) { service in
                        // En BarberDetailView, cambia el NavigationLink a:
                        NavigationLink(destination: {
                            let bvm = BookingViewModel(appointmentsStore: appointmentsVM)
                            BookingView(barber: barber, service: service, vm: bvm)
                        }) {
                            ServiceRow(service: service)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(barber.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ServiceRow: View {
    let service: BarberService
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.headline)
                Text("\(service.duration) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("$\(Int(service.price))")
                .font(.headline)
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}
