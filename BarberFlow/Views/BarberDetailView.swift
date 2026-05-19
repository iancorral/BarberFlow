import SwiftUI

struct BarberDetailView: View {
    let barber: Barber
    @EnvironmentObject var appointmentsVM: AppointmentsViewModel

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // Avatar header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.brandSurfaceAlt)
                            .frame(width: 90, height: 90)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.brandTextTertiary)
                            }
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.brandWood.opacity(0.25), lineWidth: 1.5)
                            }

                        Text(barber.name)
                            .font(BrandFont.display(22))
                            .foregroundStyle(Color.brandTextPrimary)

                        Text(barber.specialty)
                            .font(BrandFont.sans(13))
                            .foregroundStyle(Color.brandTextSecondary)

                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.brandWood)
                                .font(.system(size: 12))
                            Text(String(format: "%.1f", barber.rating))
                                .font(BrandFont.sans(13, weight: .semibold))
                                .foregroundStyle(Color.brandTextSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)

                    // Divider
                    Rectangle()
                        .fill(Color.brandWood.opacity(0.12))
                        .frame(height: 1)
                        .padding(.horizontal)

                    // Servicios
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Servicios")
                            .font(BrandFont.sans(11, weight: .semibold))
                            .foregroundStyle(Color.brandTextTertiary)
                            .kerning(1.2)
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(SampleData.services) { service in
                            NavigationLink(destination: {
                                let bvm = BookingViewModel(appointmentsStore: appointmentsVM)
                                BookingView(barber: barber, service: service, vm: bvm)
                            }) {
                                ServiceRow(service: service)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationTitle(barber.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ServiceRow: View {
    let service: BarberService

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.brandWood.opacity(0.08))
                .frame(width: 42, height: 42)
                .overlay {
                    Image(systemName: "scissors")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.brandWood)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(service.name)
                    .font(BrandFont.sans(14, weight: .semibold))
                    .foregroundStyle(Color.brandTextPrimary)
                Text("\(service.duration) min")
                    .font(BrandFont.sans(12))
                    .foregroundStyle(Color.brandTextTertiary)
            }

            Spacer()

            Text("$\(Int(service.price))")
                .font(BrandFont.sans(15, weight: .semibold))
                .foregroundStyle(Color.brandWood)

            Image(systemName: "chevron.right")
                .foregroundStyle(Color.brandTextTertiary)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(14)
        .cardStyle()
    }
}
