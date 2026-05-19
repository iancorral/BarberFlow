import SwiftUI

struct BookingView: View {
    let barber: Barber
    let service: BarberService

    @ObservedObject var vm: BookingViewModel
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    BookingSummaryCard(barber: barber, service: service)
                        .padding(.horizontal)

                    // Fecha
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Elige el día", icon: "calendar")
                        DatePicker(
                            "Fecha",
                            selection: $vm.selectedDate,
                            in: vm.minimumDate...vm.maximumDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .tint(Color.brandWood)
                        .padding(.horizontal)
                        .onChange(of: vm.selectedDate) {
                            vm.selectedHour = nil
                        }
                    }

                    // Hora
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Elige la hora", icon: "clock")
                        TimeGrid(slots: vm.availableSlots, selected: $vm.selectedHour)
                            .padding(.horizontal)
                    }

                    // Botón
                    Button(action: {
                        vm.confirmBooking()
                        showSuccess = true
                    }) {
                        Text("Confirmar cita")
                            .font(BrandFont.sans(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(vm.canBook ? Color.brandWood : Color.brandTextTertiary)
                            .foregroundStyle(Color.brandBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(!vm.canBook)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Reservar cita")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.selectedBarber = barber
            vm.selectedService = service
        }
        .alert("Cita confirmada", isPresented: $showSuccess) {
            Button("Ver mis citas") { dismiss() }
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Tu cita con \(barber.name) para \(service.name) ha sido reservada.")
        }
    }
}

struct BookingSummaryCard: View {
    let barber: Barber
    let service: BarberService

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.brandWood.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "scissors")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.brandWood)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(service.name)
                    .font(BrandFont.sans(15, weight: .semibold))
                    .foregroundStyle(Color.brandTextPrimary)
                Text("con \(barber.name)")
                    .font(BrandFont.sans(13))
                    .foregroundStyle(Color.brandTextSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("$\(Int(service.price))")
                    .font(BrandFont.sans(16, weight: .semibold))
                    .foregroundStyle(Color.brandWood)
                Text("\(service.duration) min")
                    .font(BrandFont.sans(12))
                    .foregroundStyle(Color.brandTextTertiary)
            }
        }
        .padding(16)
        .background(Color.brandSurfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.brandWood)
                .frame(width: 3, height: 16)
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Color.brandWood)
            Text(title)
                .font(BrandFont.sans(15, weight: .semibold))
                .foregroundStyle(Color.brandTextPrimary)
        }
        .padding(.horizontal)
    }
}

struct TimeGrid: View {
    let slots: [(hour: Int, available: Bool)]
    @Binding var selected: Int?

    let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(slots, id: \.hour) { slot in
                TimeSlotButton(
                    hour: slot.hour,
                    available: slot.available,
                    isSelected: selected == slot.hour
                ) {
                    if slot.available { selected = slot.hour }
                }
            }
        }
    }
}

struct TimeSlotButton: View {
    let hour: Int
    let available: Bool
    let isSelected: Bool
    let action: () -> Void

    var label: String {
        let h = hour > 12 ? hour - 12 : hour
        let ampm = hour >= 12 ? "pm" : "am"
        return "\(h):00\(ampm)"
    }

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(BrandFont.sans(13, weight: isSelected ? .semibold : .regular))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(background)
                .foregroundStyle(foreground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? Color.brandWood : Color.brandSurfaceAlt,
                            lineWidth: isSelected ? 1.5 : 1
                        )
                }
        }
        .disabled(!available)
    }

    var background: Color {
        if !available { return Color.brandSurfaceAlt }
        if isSelected { return Color.brandWood.opacity(0.1) }
        return Color.brandSurface
    }

    var foreground: Color {
        if !available { return Color.brandTextTertiary }
        if isSelected { return Color.brandWood }
        return Color.brandTextPrimary
    }
}
