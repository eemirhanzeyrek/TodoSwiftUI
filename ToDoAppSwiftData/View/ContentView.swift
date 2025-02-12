import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ToDo.isCompleted) private var toDos: [ToDo]
    
    @State private var isAlertShowing = false
    @State private var toDoTitle = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(toDos) { toDo in
                    HStack {
                        Button {
                            toDo.isCompleted.toggle()
                        } label: {
                            Image(systemName: toDo.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        
                        Text(toDo.title)
                    }
                }
                .onDelete(perform: deleteToDos)
            }
            .navigationTitle("Todo")
            .toolbar {
                Button {
                    isAlertShowing.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .alert("Add Todo", isPresented: $isAlertShowing) {
                TextField("Enter todo...", text: $toDoTitle)
                
                Button {
                    modelContext.insert(ToDo(title: toDoTitle, isCompleted: false))
                    
                    toDoTitle = ""
                } label: {
                    Text("Add")
                }
                
                Button {
                    isAlertShowing = false
                } label: {
                    Text("Exit")
                }
            }
            .overlay {
                if toDos.isEmpty {
                    ContentUnavailableView("Great! All tasks completed.", systemImage: "checkmark.circle.fill")
                }
            }
        }
    }
    
    func deleteToDos(_ indexSet: IndexSet) {
        for index in indexSet {
            let toDo = toDos[index]
            modelContext.delete(toDo)
        }
    }
}

#Preview {
    ContentView()
}
