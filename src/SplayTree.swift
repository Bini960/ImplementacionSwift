import Foundation

// Utiliza referencias de clase para optimizar la gestión de memoria del hardware mediante ARC.
class SplayTree {
    
    // Raíz del árbol. Es opcional porque el árbol puede estar vacío.
    var raiz: Nodo?
    
    // Inicializador que crea un árbol vacío.
    // Complejidad: O(1).
    init() {
        self.raiz = nil
    }
    
    // Rotación Zig (Rotación a la derecha).
    // Eleva el hijo izquierdo al lugar de su padre, balanceando el subárbol hacia la derecha.
    // Complejidad O(1).
    private func zig(_ x: Nodo) {
        guard let y = x.izquierdo else { return } // Verificación segura de nulidad.
        
        x.izquierdo = y.derecho
        if let yDerecho = y.derecho {
            yDerecho.padre = x
        }
        
        y.padre = x.padre
        
        if x.padre == nil {
            self.raiz = y
        } else if x === x.padre?.derecho {
            x.padre?.derecho = y
        } else {
            x.padre?.izquierdo = y
        }
        
        y.derecho = x
        x.padre = y
    }
    
    // Rotación Zag (Rotación a la izquierda).
    // Eleva el hijo derecho al lugar de su padre, balanceando el subárbol hacia la izquierda.
    // Complejidad O(1).
    private func zag(_ x: Nodo) {
        guard let y = x.derecho else { return } // Evita excepciones en tiempo de ejecución.
        
        x.derecho = y.izquierdo
        if let yIzquierdo = y.izquierdo {
            yIzquierdo.padre = x
        }
        
        y.padre = x.padre
        
        if x.padre == nil {
            self.raiz = y
        } else if x === x.padre?.izquierdo {
            x.padre?.izquierdo = y
        } else {
            x.padre?.derecho = y
        }
        
        y.izquierdo = x
        x.padre = y
    }
    
    // Función de auto-optimización (Adaptación según frecuencia de acceso)
    // Mueve el nodo especificado a la raíz aplicando una serie de rotaciones zig y zag.
    // Busca un proceso y lo mueve a la raíz (Complejidad amortizada O(log n)).
    private func splay(_ nodo: Nodo) {
        while let padre = nodo.padre {
            if padre.padre == nil {
                // Caso base: El padre es la raíz. Se aplica una rotación simple.
                if nodo === padre.izquierdo {
                    zig(padre)
                } else {
                    zag(padre)
                }
            } else {
                // Caso complejo: Involucra al abuelo del nodo.
                let abuelo = padre.padre!
                
                // Izquierda-Izquierda
                if nodo === padre.izquierdo && padre === abuelo.izquierdo {
                    zig(abuelo)
                    zig(padre)
                }
                // Derecha-Derecha
                else if nodo === padre.derecho && padre === abuelo.derecho {
                    zag(abuelo)
                    zag(padre)
                }
                // Izquierda-Derecha
                else if nodo === padre.derecho && padre === abuelo.izquierdo {
                    zag(padre)
                    zig(abuelo)
                }
                // Derecha-Izquierda
                else {
                    zig(padre)
                    zag(abuelo)
                }
            }
        }
    }
    
    // Inserta un nuevo proceso en el árbol y lo sube a la raíz.
    // Complejidad amortizada: O(\log n).
    func insertar(_ proceso: Proceso) {
        let nuevoNodo = Nodo(proceso: proceso)
        var actual = self.raiz
        var padreTemp: Nodo? = nil
        
        // Recorrido clásico de inserción en un BST.
        while let nodoActual = actual {
            padreTemp = nodoActual
            if proceso.id < nodoActual.id {
                actual = nodoActual.izquierdo
            } else if proceso.id > nodoActual.id {
                actual = nodoActual.derecho
            } else {
                // Si el ID ya existe, se optimiza el árbol y evita duplicados.
                splay(nodoActual)
                return
            }
        }
        
        nuevoNodo.padre = padreTemp
        
        if padreTemp == nil {
            self.raiz = nuevoNodo
        } else if proceso.id < padreTemp!.id {
            padreTemp?.izquierdo = nuevoNodo
        } else {
            padreTemp?.derecho = nuevoNodo
        }
        
        // Al insertar un nuevo elemento, se convierte en el más consultado recientemente.
        splay(nuevoNodo)
    }
    
    // Busca un proceso por su ID. Si lo encuentra, lo mueve a la raíz.
    // Complejidad amortizada: O(\log n).
    func buscar(id: String) -> Nodo? {
        var actual = self.raiz
        var ultimoVisitado: Nodo? = nil
        
        // Búsqueda binaria iterativa.
        while let nodoActual = actual {
            ultimoVisitado = nodoActual
            if id == nodoActual.id {
                splay(nodoActual)
                return nodoActual
            } else if id < nodoActual.id {
                actual = nodoActual.izquierdo
            } else {
                actual = nodoActual.derecho
            }
        }
        
        // Si no se encuentra, mueve el último nodo visitado a la raíz para optimizar futuras búsquedas cercanas.
        if let ultimo = ultimoVisitado {
            splay(ultimo)
        }
        
        return nil
    }

    /// Recorrido inorden (izquierda, raíz, derecha): en un BST por `id` deja los ids ordenados lexicográficamente.
    /// No modifica el árbol; útil para depuración o comprobar el contenido sin pasar por el diccionario.
    func idsEnInorden() -> [String] {
        var resultado: [String] = []
        func visitar(_ nodo: Nodo?) {
            guard let nodo = nodo else { return }
            visitar(nodo.izquierdo)
            resultado.append(nodo.id)
            visitar(nodo.derecho)
        }
        visitar(raiz)
        return resultado
    }
}