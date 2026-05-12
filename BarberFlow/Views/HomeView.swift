import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bienvenido ✂️")
                        .font(.largeTitle.bold())
                    Text("¿Con quién quieres tu cita hoy?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Próxima cita (si hay)
                if let next = appointmentsVM.upcoming.first {
                    NextAppointmentCard(appointment: next)
                        .padding(.horizontal)
                }
                
                // Lista de barberos
                Text("Nuestros barberos")
                    .font(.title2.bold())
                    .padding(.horizontal)
                
                ForEach(SampleData.barbers) { barber in
                    NavigationLink(destination: BarberDetailView(barber: barber)) {
                        BarberCard(barber: barber)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BarberCard: View {
    let barber: Barber
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 64, height: 64)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(barber.name)
                    .font(.headline)
                Text(barber.specialty)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", barber.rating))
                        .font(.caption.bold())
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

struct NextAppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Próxima cita", systemImage: "calendar.badge.clock")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.barber.name)
                        .font(.headline)
                    Text(appointment.service.name)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(appointment.formattedTime)
                        .font(.title2.bold())
                    Text(appointment.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.accentColor.opacity(0.2), lineWidth: 1)
        }
    }
}
