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
                    HStack {
                        Text("Apps & Websites")
                        Spacer()
                        Button {
                            appsAndWebsites()
                        } label: {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                Text("Select")
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        Image(systemName: "chevron.right")
                            .opacity(0.5)
                    }
                    .onTapGesture {
                        appsAndWebsites()
                    }
                    HStack {
                        Text("All day")
                        Spacer()
                        Toggle("", isOn: $viewModel.isAllDays)
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
                .padding(.leading, -16)
                .padding(.trailing, -16)
                    
            }
            .listSectionSpacing(0)
        }
    }
    
    private var daysOfWeekCounter: some View {
        VStack {
            HStack {
                ForEach($viewModel.daysOfWeek) { $item in
                    Button {
                        $item.state.wrappedValue = !$item.state.wrappedValue
                    } label: {
                        Text(item.title)
                            .padding(.horizontal, 3)
                            .padding(.vertical, 3)
                    }
                    .tint(item.state ? Color.indigo : Color.gray)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .cornerRadius(15.0)
                    if !item.last {
                        Spacer()
                    }
                }
            }
            HStack {
                Text("Days of week active (7 of \(viewModel.daysSelected())")
                    .font(.system(size: 16))
                Spacer()
            }
        }
    }
    
    private func appsAndWebsites() {
        print("Select")
    }
    
}

#Preview {
}

extension MainView {
    @MainActor class MainViewModel: ObservableObject {
        @Published var isAllDays = false
        @Published var starts = Date.now
        @Published var ends = Date.now
        @Published var daysOfWeek: [DayOfWeekItem] = [
            DayOfWeekItem("M"),
            DayOfWeekItem("T"),
            DayOfWeekItem("W"),
            DayOfWeekItem("T"),
            DayOfWeekItem("F"),
            DayOfWeekItem("S"),
            DayOfWeekItem("S", true)]
        
        let center = AuthorizationCenter.shared
        
        init() {
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                } catch {
                    print("Failed with \(error)")
                }
            }
            
        }
        
        func daysSelected() -> Int {
            return daysOfWeek.filter {
                item in item.state
            }
            .count
        }
        
        deinit {
            
        }
        
    }
}


