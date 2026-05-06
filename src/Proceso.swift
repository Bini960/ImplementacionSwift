import Foundation

/// Representa una tarea o proceso del sistema (datos simples del dominio).
class Proceso {

    /// Identificador único (es la clave en el diccionario y en el árbol).
    let id: String

    /// Nombre legible para mostrar en consola o en la UI.
    var nombre: String

    /// Número mayor = más urgente (solo para tu lógica de negocio; el árbol ordena por `id`).
    var prioridad: Int

    init(id: String, nombre: String, prioridad: Int = 0) {
        self.id = id
        self.nombre = nombre
        self.prioridad = prioridad
    }
}
