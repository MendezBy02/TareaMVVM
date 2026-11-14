//
//  ContentView.swift
//  TareaMVVM
//

import SwiftUI

// VIEW: solo dibuja la pantalla y le avisa al ViewModel lo que hace el usuario.
struct ContentView: View {

    // @StateObject crea el ViewModel UNA vez y lo mantiene vivo
    @StateObject private var viewModel = TareasViewModel()

    var body: some View {
        NavigationView {
            VStack { // VStack = acomoda elementos de arriba hacia abajo

                // HStack = acomoda elementos de izquierda a derecha
                HStack {
                    // $ = conexión de ida y vuelta con el texto del ViewModel
                    TextField("Nueva tarea...", text: $viewModel.nuevoTitulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Al tocar el botón, se ejecuta agregarTarea() del ViewModel
                    Button(action: viewModel.agregarTarea) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                }
                .padding()

                // Lista que muestra cada tarea del ViewModel
                List {
                    ForEach(viewModel.tareas) { tarea in
                        HStack {
                            // Ícono: palomita verde si está hecha, círculo gris si no
                            Image(systemName: tarea.completada ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(tarea.completada ? .green : .gray)

                            Text(tarea.titulo)
                                .strikethrough(tarea.completada) // tacha el texto si está hecha
                        }
                        .contentShape(Rectangle()) // toda la fila se puede tocar
                        .onTapGesture {
                            viewModel.alternarCompletada(tarea)
                        }
                    }
                    .onDelete(perform: viewModel.eliminar) // deslizar para borrar
                }
            }
            .navigationTitle("Mis tareas")
            .toolbar {
                Text("Pendientes: \(viewModel.pendientes)")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // en iPad se ve igual que en iPhone
    }
}

// Vista previa para el panel derecho de Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
