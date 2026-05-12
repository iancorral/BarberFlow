import Foundation

struct Appointment: Identifiable {
    let id: UUID
    let barber: Barber
    let service: BarberService
    let date: Date
    var status: AppointmentStatus
    
    enum AppointmentStatus {
        case upcoming, completed, cancelled
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "EEEE d 'de' MMMM"
        return formatter.string(from: date).capitalized
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    init(id: UUID = UUID(), barber: Barber, service: BarberService, date: Date, status: AppointmentStatus = .upcoming) {
        self.id = id
        self.barber = barber
        self.service = service
        self.date = date
        self.status = status
    }
}
