//
//  Tarea.swift
//  TareaMVVM
//

import Foundation

// MODEL: representa UNA tarea. Solo guarda datos, no tiene lógica ni pantalla.
struct Tarea: Identifiable, Codable {
    var id = UUID()               // identificador único, generado automáticamente
    var titulo: String            // el texto de la tarea, ej: "Estudiar Swift"
    var completada: Bool = false  // empieza como NO completada
}
