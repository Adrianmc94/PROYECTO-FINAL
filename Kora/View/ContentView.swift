import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.timestamp, order: .reverse) private var expenses: [Expense]
    
    @State private var showingScanner = false

    var body: some View {
        NavigationStack {
            List {
                if expenses.isEmpty {
                    ContentUnavailableView("Sin Gastos", systemImage: "plus.viewfinder", description: Text("Pulsa + para escanear un ticket"))
                } else {
                    ForEach(expenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.merchantName)
                                    .font(.headline)
                                Text(expense.timestamp, style: .date)
                                    .font(.caption)
                            }
                            Spacer()
                            Text("\(expense.totalAmount, specifier: "%.2f")€")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .navigationTitle("Kora")
            .toolbar {
                Button(action: { showingScanner = true }) {
                    Image(systemName: "plus.viewfinder")
                }
             }
            .sheet(isPresented: $showingScanner) {
                ScannerView { imagen in
                    let ocr = OCRService()
                    ocr.processImage(imagen) { texto, importe in
                        let nuevoGasto = Expense(
                            merchantName: "Ticket Escaneado",
                            totalAmount: importe ?? 0.0
                        )
                        modelContext.insert(nuevoGasto)
                    }
                }
            }
        }
    }
}
