import Foundation

struct SampleData {
    static let services: [BarberService] = [
        BarberService(name: "Corte clásico", duration: 30, price: 150),
        BarberService(name: "Corte + barba", duration: 60, price: 250),
        BarberService(name: "Barba", duration: 30, price: 120),
        BarberService(name: "Corte + tratamiento", duration: 75, price: 350),
        BarberService(name: "Afeitado navaja", duration: 45, price: 180)
    ]
    
    static let barbers: [Barber] = [
        Barber(name: "Carlos Mendoza", specialty: "Fade & Degradado", rating: 4.9, imageName: "person.fill"),
        Barber(name: "Diego Ramírez", specialty: "Barba & Afeitado", rating: 4.7, imageName: "person.fill"),
        Barber(name: "Andrés Torres", specialty: "Corte clásico", rating: 4.8, imageName: "person.fill"),
    ]
    
    // Horas de trabajo disponibles por defecto (9am a 7pm)
    static func workingHours() -> [Int] {
        Array(9...18)
    }
}
