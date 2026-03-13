import SwiftUI
import SwiftData

@main
struct KoraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Aquí es donde le decimos a la App que use nuestro modelo de Gastos
        .modelContainer(for: Expense.self)
    }
}
