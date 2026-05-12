import Foundation
import Combine

@MainActor
class AppointmentsViewModel: ObservableObject {
    
    @Published private(set) var appointments: [Appointment] = []
    
    // Citas próximas ordenadas
    var upcoming: [Appointment] {
        appointments
            .filter { $0.status == .upcoming && $0.date >= Date() }
            .sorted { $0.date < $1.date }
    }
    
    // Historial
    var past: [Appointment] {
        appointments
            .filter { $0.status != .upcoming || $0.date < Date() }
            .sorted { $0.date > $1.date }
    }
    
    func add(_ appointment: Appointment) {
        appointments.append(appointment)
    }
    
    func cancel(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[index].status = .cancelled
        }
    }
    
    // Retorna horas ya reservadas para un barbero en una fecha específica
    func bookedHours(for barber: Barber, on date: Date) -> Set<Int> {
        let calendar = Calendar.current
        let filtered = appointments.filter {
            $0.barber.id == barber.id &&
            $0.status == .upcoming &&
            calendar.isDate($0.date, inSameDayAs: date)
        }
        let hours = filtered.compactMap { calendar.component(.hour, from: $0.date) }
        return Set(hours)
    }
}
