import Foundation

struct BarberService: Identifiable, Hashable {
    let id: UUID
    let name: String
    let duration: Int  // en minutos
    let price: Double
    
    init(id: UUID = UUID(), name: String, duration: Int, price: Double) {
        self.id = id
        self.name = name
        self.duration = duration
        self.price = price
    }
}
