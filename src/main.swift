import Foundation

let gestor = Gestor()

func leerLinea(_ mensaje: String) -> String {
    print(mensaje, terminator: "")
    return readLine(strippingNewline: true) ?? ""
}

func leerEntero(_ mensaje: String) -> Int? {
    let t = leerLinea(mensaje).trimmingCharacters(in: .whitespaces)
    return Int(t)
}

func pausa() {
    _ = leerLinea("\nPresiona Enter para volver al menú…")
}

func listarPorId() {
    if gestor.porId.isEmpty {
        print("No hay procesos registrados.")
        return
    }
    print("Procesos (orden por id):")
    for p in gestor.porId.values.sorted(by: { $0.id < $1.id }) {
        print("  \(p.id) — \(p.nombre) (prioridad \(p.prioridad))")
    }
}

func mostrarInorden() {
    let ids = gestor.idsEnInordenArbol()
    if ids.isEmpty {
        print("El árbol está vacío.")
    } else {
        print("Inorden del árbol (claves BST):", ids.joined(separator: ", "))
    }
}

func mostrarMenu() {
    print("""
    \n=== Gestor de procesos (Splay + diccionario) ===
    1  Agregar proceso (id asignado: P-000001, P-000002, …)
    2  Listar todos ordenados por id
    3  Ver recorrido inorden del árbol (orden de claves en el BST)
    4  Buscar por id (aplica splay: ese nodo sube a la raíz)
    5  Finalizar proceso (eliminar por id)
    6  Listar ordenados por prioridad (mayor prioridad primero)
    0  Salir
    """)
}

menu: while true {
    mostrarMenu()
    let op = leerLinea("Opción: ").trimmingCharacters(in: .whitespaces)

    switch op {
    case "1":
        let nombre = leerLinea("Nombre del proceso: ")
        if nombre.isEmpty {
            print("El nombre no puede estar vacío.")
            break
        }
        let pr = leerEntero("Prioridad (entero, Enter o 0 si omites): ") ?? 0
        let id = gestor.registrarProceso(nombre: nombre, prioridad: pr)
        print("Registrado con id: \(id)")
    case "2":
        listarPorId()
    case "3":
        mostrarInorden()
    case "4":
        let id = leerLinea("Id a buscar (ej. P-000001): ").trimmingCharacters(in: .whitespaces)
        if id.isEmpty {
            print("Id vacío.")
            break
        }
        if let p = gestor.buscar(id: id) {
            print("Encontrado: \(p.id) — \(p.nombre) (prioridad \(p.prioridad))")
        } else {
            print("No existe ningún proceso con ese id.")
        }
    case "5":
        let id = leerLinea("Id del proceso a finalizar: ").trimmingCharacters(in: .whitespaces)
        if gestor.porId[id] == nil {
            print("No hay proceso con ese id.")
        } else {
            gestor.finalizar(id: id)
            print("Proceso \(id) eliminado.")
        }
    case "6":
        let lista = gestor.procesosOrdenadosPorPrioridad()
        if lista.isEmpty {
            print("No hay procesos registrados.")
        } else {
            print("Por prioridad (descendente), desempate por id:")
            for p in lista {
                print("  prioridad \(p.prioridad) — \(p.id) — \(p.nombre)")
            }
        }
    case "0":
        print("Fin.")
        break menu
    default:
        print("Opción no válida.")
    }
    pausa()
}
