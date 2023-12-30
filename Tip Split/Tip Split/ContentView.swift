//
//  ContentView.swift
//  Tip Split
//
//  Created by Tony Alhwayek on 12/18/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 15
    @State private var totalBill = "$0.00"
    let tipAmount = [0, 10, 15, 20, 25]
    
    // To handle keyboard not closing
    @FocusState private var totalIsFocused: Bool
    
    // Return tip total
    var calculateTipAmount: Double {
        return calculateTotal - (Double(totalBill) ?? 0.00)
    }
    
    // Returns total (pre-split)
    var calculateTotal: Double {
        let tipDbl = Double(tipPercentage) / 100 + 1
        let billDbl = Double(totalBill.replacingOccurrences(of: "$", with: "")) ?? 0.00
        
        return billDbl * tipDbl
    }
    
    // Returns total per person (post-split)
    var calculateSplit: Double {
        let peopleDbl = Double(numberOfPeople) + 2
        
        return calculateTotal / peopleDbl
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Check amount section
                Section("Check amount") {
                    HStack {
                        Text("Amount:")
                        TextField("$0.00", text: $totalBill)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($totalIsFocused)
                            .onTapGesture {
                                totalBill = "$"
                            }
                    }
                    
                    // Tip section
                    Picker("Group size:", selection: $numberOfPeople) {
                        ForEach(2..<21) {
                            Text("\($0) people")
                        }
                    }
                    
                    HStack {
                        Text("Tip: ")
                        Picker("Tip percentage:", selection: $tipPercentage) {
                            ForEach(tipAmount, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                // Displaying totals section
                Section("Totals") {
                    // Display tip
                    HStack {
                        Text("Tip amount:")
                        Spacer()
                        Text(calculateTipAmount, format:
                                .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .multilineTextAlignment(.trailing)
                    }
                    // Proj #3 - Challenge #1
                    .foregroundStyle(tipPercentage == 0 ? .red : .black)
                    
                    
                    // Display grand total
                    HStack {
                        Text("Grand total: ")
                        Spacer()
                        Text(calculateTotal, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Display total per person
                    HStack {
                        Text("Total per person: ")
                        Spacer()
                        Text(calculateSplit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Tip Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    if totalIsFocused {
                        Button("Done") {
                            totalIsFocused = false
                            
                            // Format the string upon pressing done
                            totalBill = totalBill.replacingOccurrences(of: "$", with: "")
                            if let billDbl = Double(totalBill) {
                                totalBill = String(format: "%.2f", billDbl)
                                totalBill = "$" + totalBill
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
