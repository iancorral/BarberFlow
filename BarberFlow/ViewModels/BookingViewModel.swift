import Foundation
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    
    // Selecciones del usuario
    @Published var selectedBarber: Barber?
    @Published var selectedService: BarberService?
    @Published var selectedDate: Date = Date()
    @Published var selectedHour: Int?
    
    // Estado de UI
    @Published var showConfirmation = false
    @Published var bookingSuccess = false
    
    // Referencia al store de citas
    private let appointmentsStore: AppointmentsViewModel
    
    init(appointmentsStore: AppointmentsViewModel) {
        self.appointmentsStore = appointmentsStore
    }
    
    // Horas bloqueadas para el barbero seleccionado en la fecha seleccionada
    var bookedHours: Set<Int> {
        guard let barber = selectedBarber else { return [] }
        return appointmentsStore.bookedHours(for: barber, on: selectedDate)
    }
    
    // Slots disponibles (trabajamos 9am-6pm)
    var availableSlots: [(hour: Int, available: Bool)] {
        SampleData.workingHours().map { hour in
            (hour: hour, available: !bookedHours.contains(hour))
        }
    }
    
    // Fecha mínima: hoy
    var minimumDate: Date { Date() }
    
    // Fecha máxima: 60 días adelante
    var maximumDate: Date {
        Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    }
    
    var canBook: Bool {
        selectedBarber != nil &&
        selectedService != nil &&
        selectedHour != nil
    }
    
    func confirmBooking() {
        guard let barber = selectedBarber,
              let service = selectedService,
              let hour = selectedHour else { return }
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        components.hour = hour
        components.minute = 0
        
        guard let appointmentDate = Calendar.current.date(from: components) else { return }
        
        let appointment = Appointment(
            barber: barber,
            service: service,
            date: appointmentDate
        )
        
        appointmentsStore.add(appointment)
        bookingSuccess = true
        resetSelection()
    }
    
    func resetSelection() {
        selectedBarber = nil
        selectedService = nil
        selectedDate = Date()
        selectedHour = nil
    }
}
