import Foundation

struct Barber: Identifiable, Hashable {
    let id: UUID
    let name: String
    let specialty: String
    let rating: Double
    let imageName: String // SF Symbol para el MVP
    
    init(id: UUID = UUID(), name: String, specialty: String, rating: Double, imageName: String) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.rating = rating
        self.imageName = imageName
    }
}
