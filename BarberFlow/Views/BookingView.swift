import SwiftUI

struct BookingView: View {
    let barber: Barber
    let service: BarberService

    @ObservedObject var vm: BookingViewModel
    @State private var showSuccess = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                BookingSummaryCard(barber: barber, service: service)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Elige el día", icon: "calendar")
                    DatePicker(
                        "Fecha",
                        selection: $vm.selectedDate,
                        in: vm.minimumDate...vm.maximumDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                    .onChange(of: vm.selectedDate) {
                        vm.selectedHour = nil
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Elige la hora", icon: "clock")
                    TimeGrid(slots: vm.availableSlots, selected: $vm.selectedHour)
                        .padding(.horizontal)
                }

                Button(action: {
                    vm.confirmBooking()
                    showSuccess = true
                }) {
                    Label("Confirmar cita", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.canBook ? Color.accentColor : Color(.systemGray4))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!vm.canBook)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Reservar cita")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.selectedBarber = barber
            vm.selectedService = service
        }
        .alert("¡Cita confirmada! 🎉", isPresented: $showSuccess) {
            Button("Ver mis citas") { dismiss() }
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Tu cita con \(barber.name) para \(service.name) ha sido reservada.")
        }
    }
}

// MARK: - Subviews

struct BookingSummaryCard: View {
    let barber: Barber
    let service: BarberService

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "scissors")
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 48, height: 48)
                .background(Color(.systemGray6))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(service.name).font(.headline)
                Text("con \(barber.name)").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(Int(service.price))").font(.headline)
                Text("\(service.duration) min").font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.title3.bold())
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
                .font(.subheadline.weight(isSelected ? .bold : .regular))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(background)
                .foregroundStyle(foreground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.accentColor, lineWidth: 2)
                    }
                }
        }
        .disabled(!available)
    }

    var background: Color {
        if !available { return Color(.systemGray6) }
        if isSelected { return Color.accentColor.opacity(0.15) }
        return Color(.systemBackground)
    }

    var foreground: Color {
        if !available { return Color(.systemGray3) }
        if isSelected { return .accentColor }
        return .primary
    }
}
