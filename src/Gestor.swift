import Foundation

/// Combina un diccionario (acceso por id) y un Splay Tree (consultas que reordenan el árbol).
class Gestor {

    /// Acceso directo por id: O(1) de media.
    var porId: [String: Proceso] = [:]

    /// Orden / frecuencia de acceso: las búsquedas suben el nodo a la raíz.
    var arbol = SplayTree()

    /// Secuencia para ids únicos del mismo tipo: `P-000001`, `P-000002`, …
    private var contadorId = 0

    /// Registra un proceso solo si el id no existe (usado internamente y por `registrarProceso`).
    private func agregar(_ proceso: Proceso) {
        if porId[proceso.id] != nil {
            return
        }
        porId[proceso.id] = proceso
        arbol.insertar(proceso)
    }

    /// Crea un proceso con id generado (`P-000001`, …). Si hubiera colisión (poco probable), avanza el contador hasta un id libre.
    @discardableResult
    func registrarProceso(nombre: String, prioridad: Int = 0) -> String {
        let id: String = {
            while true {
                contadorId += 1
                let candidato = String(format: "P-%06d", contadorId)
                if porId[candidato] == nil {
                    return candidato
                }
            }
        }()
        agregar(Proceso(id: id, nombre: nombre, prioridad: prioridad))
        return id
    }

    /// Ids del splay en recorrido inorden (orden lexicográfico de clave en el BST actual).
    func idsEnInordenArbol() -> [String] {
        arbol.idsEnInorden()
    }

    /// Lista para mostrar prioridades sin depender del árbol (el BST ordena por `id`, no por prioridad).
    func procesosOrdenadosPorPrioridad() -> [Proceso] {
        porId.values.sorted {
            if $0.prioridad != $1.prioridad {
                return $0.prioridad > $1.prioridad
            }
            return $0.id < $1.id
        }
    }

    /// Devuelve el proceso si existe. Si está en el diccionario, también busca en el árbol
    /// para aplicar el splay (tarea “más consultada” sube a la raíz).
    func buscar(id: String) -> Proceso? {
        guard let proceso = porId[id] else {
            return nil
        }
        _ = arbol.buscar(id: id)
        return proceso
    }

    /// Quita el proceso del diccionario y reconstruye el árbol con lo que queda.
    /// Así ARC puede liberar el proceso si nadie más lo retiene.
    func finalizar(id: String) {
        porId[id] = nil
        arbol = SplayTree()
        for p in porId.values {
            arbol.insertar(p)
        }
    }
}
