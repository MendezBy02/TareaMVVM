//
//  ContentView.swift
//  TareaMVVM
//

import SwiftUI

// VIEW: dibuja la pantalla como una hoja de cuaderno y le avisa al ViewModel lo que hace el usuario.
struct ContentView: View {

    // @StateObject crea el ViewModel UNA vez y lo mantiene vivo
    @StateObject private var viewModel = TareasViewModel()

    // Renglones vacíos al final para que se vea como una hoja completa
    private let renglonesVacios = 14

    var body: some View {
        // ZStack = apila elementos uno encima de otro (el papel abajo, el contenido arriba)
        ZStack(alignment: .leading) {
            Libreta.papel
                .ignoresSafeArea()

            // Línea roja vertical del margen, de arriba a abajo de la pantalla
            Rectangle()
                .fill(Libreta.margen)
                .frame(width: 1.5)
                .padding(.leading, Libreta.anchoMargen)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                encabezado
                barraNuevaTarea

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.tareas) { tarea in
                            TareaRenglonView(
                                tarea: tarea,
                                alMarcar: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        viewModel.alternarCompletada(tarea)
                                    }
                                },
                                alBorrar: {
                                    withAnimation { viewModel.eliminar(tarea) }
                                }
                            )
                        }

                        // Si no hay tareas, el primer renglón da la indicación
                        if viewModel.tareas.isEmpty {
                            renglonDePista
                        }

                        ForEach(0..<renglonesVacios, id: \.self) { _ in
                            Color.clear
                                .frame(height: Libreta.altoRenglon)
                                .overlay(LineaRenglon(), alignment: .bottom)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light) // el papel siempre es blanco, aunque el iPhone esté en modo oscuro
    }

    // MARK: - Partes de la pantalla

    // Fecha, título y la "nota a mano" con el contador
    private var encabezado: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.fechaDeHoy)
                    .font(.subheadline)
                    .foregroundColor(Libreta.lapiz)

                Text("Mis tareas")
                    .font(Libreta.letraTitulo)
                    .foregroundColor(Libreta.tinta)
            }

            Spacer()

            // Contador como nota en lapicero rojo, un poco inclinada
            Text(viewModel.resumen)
                .font(Libreta.letraNota)
                .foregroundColor(Libreta.rojo)
                .rotationEffect(.degrees(-6))
                .padding(.bottom, 6)
                .animation(.spring(), value: viewModel.resumen)
        }
        .padding(.leading, Libreta.anchoMargen + 14)
        .padding(.trailing, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // Campo para escribir una tarea nueva + botón para agregarla
    private var barraNuevaTarea: some View {
        HStack(spacing: 0) {
            // Lápiz dentro del margen, alineado con las casillas de abajo
            Image(systemName: "pencil")
                .foregroundColor(Libreta.lapiz)
                .frame(width: Libreta.anchoMargen)

            // $ = conexión de ida y vuelta con el texto del ViewModel
            TextField("Escribe una tarea nueva…", text: $viewModel.nuevoTitulo)
                .font(Libreta.letraTarea)
                .foregroundColor(Libreta.tinta)
                .submitLabel(.done)
                .onSubmit(viewModel.agregarTarea) // la tecla "Listo" también agrega
                .padding(.leading, 14)

            Button(action: viewModel.agregarTarea) {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Libreta.tinta)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .disabled(!viewModel.puedeAgregar)          // apagado si no hay texto
            .opacity(viewModel.puedeAgregar ? 1 : 0.35)
            .accessibilityLabel("Agregar tarea")
            .padding(.trailing, 20)
        }
        .padding(.vertical, 10)
        // Línea gruesa azul marino que separa el encabezado de la lista
        .overlay(
            Rectangle().fill(Libreta.tinta).frame(height: 2),
            alignment: .bottom
        )
    }

    // Renglón que aparece cuando la hoja está vacía
    private var renglonDePista: some View {
        HStack(spacing: 0) {
            Color.clear.frame(width: Libreta.anchoMargen)
            Text("Página en blanco: escribe arriba tu primera tarea")
                .font(Libreta.letraTarea)
                .foregroundColor(Libreta.lapiz)
                .padding(.leading, 14)
            Spacer()
        }
        .frame(minHeight: Libreta.altoRenglon)
        .overlay(LineaRenglon(), alignment: .bottom)
    }
}

// Vista previa para el panel derecho de Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
