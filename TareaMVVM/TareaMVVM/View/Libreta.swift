//
//  Libreta.swift
//  TareaMVVM
//

import SwiftUI

// TEMA VISUAL: todos los colores, letras y medidas del diseño "libreta" en un solo lugar.
// Si quieres cambiar el estilo de toda la app, solo tocas este archivo.
enum Libreta {

    // MARK: - Colores (como un cuaderno escolar)
    static let papel   = Color.white                                  // la hoja
    static let renglon = Color(red: 0.79, green: 0.86, blue: 0.94)    // líneas azul claro
    static let margen  = Color(red: 0.88, green: 0.40, blue: 0.40)    // línea roja del margen
    static let tinta   = Color(red: 0.12, green: 0.23, blue: 0.37)    // "lapicero" azul marino
    static let lapiz   = Color(red: 0.54, green: 0.58, blue: 0.65)    // gris para textos secundarios
    static let rojo    = Color(red: 0.75, green: 0.22, blue: 0.17)    // "lapicero rojo" de corrección

    // MARK: - Letras
    // Noteworthy es una letra tipo "escrita a mano" que ya viene instalada en iOS.
    static let letraTarea = Font.custom("Noteworthy-Light", size: 19)
    static let letraNota  = Font.custom("Noteworthy-Bold", size: 22)
    static let letraTitulo = Font.system(size: 36, weight: .bold, design: .serif)

    // MARK: - Medidas
    static let anchoMargen: CGFloat = 52   // distancia del borde izquierdo a la línea roja
    static let altoRenglon: CGFloat = 52   // alto de cada renglón
}
