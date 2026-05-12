import SwiftUI

struct AppointmentsView: View {
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel
    
    var body: some View {
        Group {
            if appointmentsVM.upcoming.isEmpty && appointmentsVM.past.isEmpty {
                EmptyAppointmentsView()
            } else {
                List {
                    if !appointmentsVM.upcoming.isEmpty {
                        Section("Próximas citas") {
                            ForEach(appointmentsVM.upcoming) { appt in
                                AppointmentRow(appointment: appt)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            appointmentsVM.cancel(appt)
                                        } label: {
                                            Label("Cancelar", systemImage: "xmark.circle")
                                        }
                                    }
                            }
                        }
                    }
                    
                    if !appointmentsVM.past.isEmpty {
                        Section("Historial") {
                            ForEach(appointmentsVM.past) { appt in
                                AppointmentRow(appointment: appt, dimmed: true)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Mis citas")
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    var dimmed: Bool = false
    
    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(appointment.formattedTime)
                    .font(.headline.monospacedDigit())
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
            }
            .frame(width: 52)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(appointment.service.name)
                    .font(.headline)
                Text("con \(appointment.barber.name)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(appointment.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            Text("$\(Int(appointment.service.price))")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
        }
        .opacity(dimmed ? 0.5 : 1)
    }
    
    var statusColor: Color {
        switch appointment.status {
        case .upcoming: return .green
        case .completed: return .blue
        case .cancelled: return .red
        }
    }
}

struct EmptyAppointmentsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 56))
                .foregroundStyle(.tertiary)
            Text("Sin citas aún")
                .font(.title3.bold())
            Text("Reserva con tu barbero favorito\ny aquí aparecerán tus citas.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
