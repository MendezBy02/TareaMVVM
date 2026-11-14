//
//  TareaRenglonView.swift
//  TareaMVVM
//

import SwiftUI

// VIEW (pieza): dibuja UNA tarea como si estuviera escrita en un renglón del cuaderno.
// No decide nada: solo avisa "me tocaron" o "bórrame" con los closures que recibe.
struct TareaRenglonView: View {

    let tarea: Tarea
    let alMarcar: () -> Void   // se ejecuta al tocar el renglón
    let alBorrar: () -> Void   // se ejecuta al pedir borrar

    var body: some View {
        HStack(spacing: 0) {
            // La casilla vive DENTRO del margen, a la izquierda de la línea roja
            Casilla(marcada: tarea.completada)
                .frame(width: Libreta.anchoMargen)

            Text(tarea.titulo)
                .font(Libreta.letraTarea)
                .foregroundColor(tarea.completada ? Libreta.lapiz : Libreta.tinta)
                .strikethrough(tarea.completada, color: Libreta.rojo) // tachado con "lapicero rojo"
                .padding(.leading, 14)
                .padding(.vertical, 12)

            Spacer(minLength: 8)

            // Solo las tareas hechas muestran la X para borrarlas rápido
            if tarea.completada {
                Button(action: alBorrar) {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Libreta.rojo)
                        .frame(width: 36, height: 36)
                }
                .accessibilityLabel("Borrar tarea")
                .padding(.trailing, 12)
            }
        }
        .frame(minHeight: Libreta.altoRenglon)
        .overlay(LineaRenglon(), alignment: .bottom)   // la línea azul debajo
        .contentShape(Rectangle())                     // todo el renglón se puede tocar
        .onTapGesture(perform: alMarcar)
        // Mantener presionado muestra un menú para borrar cualquier tarea
        .contextMenu {
            Button(role: .destructive, action: alBorrar) {
                Label("Borrar tarea", systemImage: "trash")
            }
        }
    }
}

// Casilla cuadrada; al marcarla aparece una palomita que "se sale" del cuadro,
// como cuando uno marca a mano.
struct Casilla: View {
    let marcada: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Libreta.tinta.opacity(0.6), lineWidth: 1.5)
                .frame(width: 22, height: 22)

            if marcada {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Libreta.tinta)
                    .offset(x: 3, y: -4)
                    .transition(.scale)
            }
        }
    }
}

// Línea azul clara de 1 punto, como el renglón de un cuaderno
struct LineaRenglon: View {
    var body: some View {
        Rectangle()
            .fill(Libreta.renglon)
            .frame(height: 1)
    }
}
