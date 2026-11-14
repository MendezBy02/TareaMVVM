//
//  TareasViewModel.swift
//  TareaMVVM
//

import Foundation
import Combine // aquí viven ObservableObject y @Published

// VIEWMODEL: es el "cerebro". Tiene la lista de tareas y todas las acciones.
// ObservableObject = la pantalla puede "observar" este objeto.
class TareasViewModel: ObservableObject {

    // @Published = cuando esta lista cambia, la pantalla se redibuja sola.
    @Published var tareas: [Tarea] = [] {
        didSet { guardar() } // cada vez que la lista cambia, se guarda
    }

    // Lo que el usuario está escribiendo en el campo de texto
    @Published var nuevoTitulo: String = ""

    // Nombre con el que se guardan los datos en el teléfono
    private let clave = "tareas_guardadas"

    // init se ejecuta al crear el ViewModel: carga las tareas guardadas
    init() {
        cargar()
    }

    // MARK: - Acciones que la vista puede pedir

    // Agrega una tarea nueva con el texto escrito
    func agregarTarea() {
        let texto = nuevoTitulo.trimmingCharacters(in: .whitespaces) // quita espacios
        guard !texto.isEmpty else { return }                         // si está vacío, no hace nada
        tareas.append(Tarea(titulo: texto))                          // crea la tarea y la agrega
        nuevoTitulo = ""                                             // limpia el campo de texto
    }

    // Marca o desmarca una tarea como completada
    func alternarCompletada(_ tarea: Tarea) {
        if let i = tareas.firstIndex(where: { $0.id == tarea.id }) {
            tareas[i].completada.toggle() // toggle = cambia true <-> false
        }
    }

    // Elimina una tarea concreta (desde la X o desde el menú de mantener presionado)
    func eliminar(_ tarea: Tarea) {
        tareas.removeAll { $0.id == tarea.id }
    }

    // Elimina tareas por posición (útil si algún día vuelves a usar List con .onDelete)
    func eliminar(en offsets: IndexSet) {
        tareas.remove(atOffsets: offsets)
    }

    // MARK: - Datos listos para mostrar en pantalla

    // Cuenta cuántas tareas faltan por hacer
    var pendientes: Int {
        tareas.filter { !$0.completada }.count
    }

    // El botón + solo se activa si hay algo escrito (sin contar espacios)
    var puedeAgregar: Bool {
        !nuevoTitulo.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // Texto de la "nota a mano" del encabezado
    var resumen: String {
        if tareas.isEmpty { return "" }
        switch pendientes {
        case 0:  return "¡Todo hecho!"
        case 1:  return "1 por hacer"
        default: return "\(pendientes) por hacer"
        }
    }

    // Fecha de hoy en español, ej: "sábado 14 de noviembre"
    var fechaDeHoy: String {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_SV")
        formato.dateFormat = "EEEE d 'de' MMMM"
        return formato.string(from: Date())
    }

    // MARK: - Almacenamiento (UserDefaults + JSON)

    // Convierte la lista a JSON y la guarda en el teléfono
    private func guardar() {
        if let data = try? JSONEncoder().encode(tareas) {
            UserDefaults.standard.set(data, forKey: clave)
        }
    }

    // Lee el JSON guardado y lo convierte de nuevo en tareas
    private func cargar() {
        if let data = UserDefaults.standard.data(forKey: clave),
           let guardadas = try? JSONDecoder().decode([Tarea].self, from: data) {
            tareas = guardadas
        }
    }
}
