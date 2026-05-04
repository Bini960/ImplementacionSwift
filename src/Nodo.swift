// Importa el framework base que proporciona las funcionalidades del sistema.
import Foundation

// Clase que representa una unidad dentro del Splay Tree.
class Nodo {
    
    // Identificador único del proceso, utilizado como llave de búsqueda en el árbol.
    var id: String
    
    // Almacena la estructura de datos con la información de la tarea.
    var proceso: Proceso
    
    // Referencias fuertes a los nodos hijos. Son Optionals (?) porque pueden ser nulos.
    var izquierdo: Nodo?
    var derecho: Nodo?
    
    // Referencia débil al nodo padre para evitar ciclos de retención de memoria.
    // Garantiza que ARC libere el nodo correctamente cuando ya no esté en uso.
    weak var padre: Nodo?
    
    // Inicializador principal del nodo.
    // Complejidad de creación O(1).
    init(proceso: Proceso) {
        self.id = proceso.id // Se asume que la estructura Proceso tiene un id
        self.proceso = proceso
        self.izquierdo = nil // Inicialmente, el nodo no tiene hijos.
        self.derecho = nil
        self.padre = nil
    }
}