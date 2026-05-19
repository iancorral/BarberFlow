import SwiftUI

struct AppointmentsView: View {
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            if appointmentsVM.upcoming.isEmpty && appointmentsVM.past.isEmpty {
                EmptyAppointmentsView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {

                        if !appointmentsVM.upcoming.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionLabel("Próximas citas")
                                ForEach(appointmentsVM.upcoming) { appt in
                                    AppointmentRow(appointment: appt)
                                        .padding(.horizontal)
                                }
                            }
                        }

                        if !appointmentsVM.past.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                sectionLabel("Historial")
                                ForEach(appointmentsVM.past) { appt in
                                    AppointmentRow(appointment: appt, dimmed: true)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Mis citas")
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(BrandFont.sans(11, weight: .semibold))
            .foregroundStyle(Color.brandTextTertiary)
            .kerning(1.2)
            .textCase(.uppercase)
            .padding(.horizontal)
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    var dimmed: Bool = false

    var body: some View {
        HStack(spacing: 14) {

            // Bloque de fecha
            VStack(spacing: 2) {
                Text(dayNumber)
                    .font(BrandFont.display(22))
                    .foregroundStyle(dimmed ? Color.brandTextTertiary : Color.brandWood)
                Text(monthAbbr)
                    .font(BrandFont.sans(11, weight: .semibold))
                    .foregroundStyle(dimmed ? Color.brandTextTertiary : Color.brandWood)
                    .textCase(.uppercase)
                    .kerning(0.5)
            }
            .frame(width: 44)
            .padding(.vertical, 10)
            .background(dimmed ? Color.brandSurfaceAlt : Color.brandWood.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        dimmed ? Color.clear : Color.brandWood.opacity(0.15),
                        lineWidth: 1
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.service.name)
                    .font(BrandFont.sans(14, weight: .semibold))
                    .foregroundStyle(Color.brandTextPrimary)
                Text("con \(appointment.barber.name)")
                    .font(BrandFont.sans(12))
                    .foregroundStyle(Color.brandTextSecondary)
                Text(appointment.formattedTime)
                    .font(BrandFont.sans(12, weight: .medium))
                    .foregroundStyle(Color.brandTextTertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("$\(Int(appointment.service.price))")
                    .font(BrandFont.sans(14, weight: .semibold))
                    .foregroundStyle(dimmed ? Color.brandTextTertiary : Color.brandWood)

                Text(statusLabel)
                    .font(BrandFont.sans(10, weight: .semibold))
                    .foregroundStyle(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(14)
        .cardStyle()
        .opacity(dimmed ? 0.6 : 1)
    }

    private var dayNumber: String {
        let cal = Calendar.current
        return String(cal.component(.day, from: appointment.date))
    }

    private var monthAbbr: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "MMM"
        return f.string(from: appointment.date)
    }

    private var statusLabel: String {
        switch appointment.status {
        case .upcoming:   return "Confirmada"
        case .completed:  return "Completada"
        case .cancelled:  return "Cancelada"
        }
    }

    private var statusColor: Color {
        switch appointment.status {
        case .upcoming:   return Color(hex: "4CAF7D")
        case .completed:  return Color.brandTextSecondary
        case .cancelled:  return Color.brandWine
        }
    }
}

struct EmptyAppointmentsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(Color.brandWood.opacity(0.08))
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay {
                    Image(systemName: "calendar")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.brandWood.opacity(0.5))
                }

            Text("Sin citas aún")
                .font(BrandFont.display(20))
                .foregroundStyle(Color.brandTextPrimary)

            Text("Reserva con tu barbero favorito\ny aquí aparecerán tus citas.")
                .font(BrandFont.sans(14))
                .foregroundStyle(Color.brandTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
