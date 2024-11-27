//
//  ContentView.swift
//  UnTrapTest1
//
//  Created by Andrew Baratjuk on 25.11.2024.
//

import SwiftUI
import SwiftData
import DeviceActivity
import FamilyControls

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink {
                        
                    } label: {
                        Text("Apps & Websites")
                    }
                    HStack {
                        Text("All day")
                        Spacer()
                        Toggle("", isOn: $viewModel.isSwitchOn)
                            .toggleStyle(.switch)
                    }
                    HStack {
                        Text("Starts")
                        Spacer()
                        DatePicker("", selection: $viewModel.starts, displayedComponents: .hourAndMinute)
                    }
                    HStack {
                        Text("Ends")
                        Spacer()
                        DatePicker("", selection: $viewModel.ends, displayedComponents: .hourAndMinute)
                    }
                }
                Section(footer: self.daysOfWeekCounter) {
                    EmptyView().frame(height:0)
                }
            }
        }
    }
    
    private var daysOfWeekCounter: some View {
        VStack {
            HStack {
                ForEach(0..<viewModel.daysOfWeek.count) { i in
                    Button {
                        $viewModel.daysOfWeek[i].state.wrappedValue = !$viewModel.daysOfWeek[i].state.wrappedValue
                    } label: {
                        Text(viewModel.daysOfWeek[i].title)
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 40, alignment: .center)
                            .background($viewModel.daysOfWeek[i].state.wrappedValue ? Color.blue : Color.gray)
                    }.cornerRadius(10.0)
                }
            }
            .padding()
            HStack {
                Text("Days of week active (7 of \(viewModel.daysSelected())")
                Spacer()
            }.padding(.leading)
        }
    }
    
}

#Preview {
}

extension MainView {
    @MainActor class MainViewModel: ObservableObject {
        @Published var isSwitchOn = false
        @Published var starts = Date.now
        @Published var ends = Date.now
        @Published var daysOfWeek: [Item] = [
            Item("M"),
            Item("T"),
            Item("W"),
            Item("T"),
            Item("F"),
            Item("S"),
            Item("S")]
        
        let center = AuthorizationCenter.shared
        
        init() {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual
                    )
                } catch {
                    print("Failed with \(error)")
                }
            }
            
        }
        
        func daysSelected() -> Int {
            return daysOfWeek.filter {
                item in item.state
            }.count
        }
        
        deinit {
            
        }
        
    }
}


