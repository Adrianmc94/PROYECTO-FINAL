import Foundation
import SwiftData

// @Model indica a SwiftData que esta clase es una tabla de la base de datos
@Model
final class Expense {
    @Attribute(.unique) var id: UUID // Un identificador único para que no haya tickets duplicados
    var timestamp: Date              // La fecha y hora de la compra
    var merchantName: String         // El nombre del comercio (ej: Mercadona, Zara)
    var totalAmount: Double          // El importe total del ticket
    var currency: String             // La moneda (EUR, PLN, USD...)
    
    // Relación: Si borramos un ticket, se borran automáticamente sus líneas de productos
    @Relationship(deleteRule: .cascade) var items: [ExpenseItem]?
    
    // Constructor: Crea un nuevo gasto con valores por defecto
    init(merchantName: String = "", totalAmount: Double = 0.0, currency: String = "EUR") {
        self.id = UUID()
        self.timestamp = Date()
        self.merchantName = merchantName
        self.totalAmount = totalAmount
        self.currency = currency
        self.items = []
    }
}

@Model
final class ExpenseItem {
    var name: String    // Nombre del producto (ej: Café, Manzanas)
    var price: Double   // Precio de ese producto individual
    var expense: Expense? // Relación para saber a qué ticket pertenece este producto
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}

