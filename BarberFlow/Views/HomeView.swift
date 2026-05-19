import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bienvenido")
                            .font(BrandFont.display(30))
                            .foregroundStyle(Color.brandTextPrimary)
                        Text("¿Con quién quieres tu cita hoy?")
                            .font(BrandFont.sans(14))
                            .foregroundStyle(Color.brandTextSecondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // Próxima cita
                    if let next = appointmentsVM.upcoming.first {
                        NextAppointmentCard(appointment: next)
                            .padding(.horizontal)
                    }

                    // Sección barberos
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Nuestros barberos")
                            .font(BrandFont.sans(12, weight: .semibold))
                            .foregroundStyle(Color.brandTextTertiary)
                            .kerning(1.2)
                            .textCase(.uppercase)
                            .padding(.horizontal)

                        ForEach(SampleData.barbers) { barber in
                            NavigationLink(destination: BarberDetailView(barber: barber)) {
                                BarberCard(barber: barber)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
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
                .fill(Color.brandSurfaceAlt)
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color.brandTextTertiary)
                }
                .overlay {
                    Circle()
                        .strokeBorder(Color.brandWood.opacity(0.2), lineWidth: 1)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(barber.name)
                    .font(BrandFont.sans(15, weight: .semibold))
                    .foregroundStyle(Color.brandTextPrimary)
                Text(barber.specialty)
                    .font(BrandFont.sans(13))
                    .foregroundStyle(Color.brandTextSecondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.brandWood)
                        .font(.system(size: 11))
                    Text(String(format: "%.1f", barber.rating))
                        .font(BrandFont.sans(12, weight: .medium))
                        .foregroundStyle(Color.brandTextSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Color.brandTextTertiary)
                .font(.system(size: 13, weight: .medium))
        }
        .padding(16)
        .cardStyle()
    }
}

struct NextAppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.brandWood)
                    .frame(width: 3, height: 14)
                Text("Próxima cita")
                    .font(BrandFont.sans(11, weight: .semibold))
                    .foregroundStyle(Color.brandWood)
                    .kerning(0.8)
                    .textCase(.uppercase)
            }

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.barber.name)
                        .font(BrandFont.sans(15, weight: .semibold))
                        .foregroundStyle(Color.brandTextPrimary)
                    Text(appointment.service.name)
                        .font(BrandFont.sans(13))
                        .foregroundStyle(Color.brandTextSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(appointment.formattedTime)
                        .font(BrandFont.display(22))
                        .foregroundStyle(Color.brandTextPrimary)
                    Text(appointment.formattedDate)
                        .font(BrandFont.sans(12))
                        .foregroundStyle(Color.brandTextSecondary)
                }
            }
        }
        .padding(16)
        .background(Color.brandWood.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.brandWood.opacity(0.18), lineWidth: 1)
        }
    }
}
