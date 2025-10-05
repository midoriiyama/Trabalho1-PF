import gleam/string
import gleam/io 
import sgleam/check
import gleam/int
import gleam/list

pub type Inscricao {
    Inscricao(id: Int,
              nome_atividade: String, 
              descricao: String, 
              nome_participante: String, 
              status_pagamento: Status, 
              data: String)
}

pub type Status {
    Pendente
    Cancelado
    Concluido
}

pub fn criar_inscricao(lista_insc: List(Inscricao), id: Int, nome_atividade: String, descricao: String, nome_participante: String, status_pagamento: Status, data: String) -> Inscricao {
    case verifica_id(lista_insc, id) {
        True -> Inscricao(id, nome_atividade, descricao, nome_participante, status_pagamento, data)
        False -> False
    }
}

pub fn verifica_id(lista_insc: List(Inscricao), id: Int) -> Bool {
    case lista_insc {
        [] -> True
        [primeiro, ..resto] if primeiro.id == id -> False
        [primeiro, ..resto] -> verifica_id(resto, id)
    }
}

pub fn adicionar_inscricao(lista_insc: List(Inscricao), inscricao: Inscricao) -> List(Inscricao) {
    let lista: List(Inscricao) = [inscricao]
    list.append(lista_insc, lista)
}

pub fn atualizar_status_pagamento(lista_insc: List(Inscricao), id: Int, status: Status) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.id == id -> {
            let inscricao: List(Inscricao) = [Inscricao(primeiro.id, primeiro.nome_atividade, primeiro.descricao, primeiro.nome_participante, status, primeiro.data)]
            list.append(inscricao, resto)
        }
        [primeiro, ..resto] -> [primeiro, ..atualizar_status_pagamento(resto, id, status)]
    }
}

pub fn filtrar_por_status(lista_insc: List(Inscricao), status: Status) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.status_pagamento != status -> filtrar_por_status(resto, status)
        [primeiro, ..resto] -> [primeiro, ..filtrar_por_status(resto, status)]
    }
}

pub fn remover_concluidos(lista_insc: List(Inscricao)) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.status_pagamento == Concluido -> remover_concluidos(resto)
        [primeiro, ..resto] -> [primeiro, ..remover_concluidos(resto)]
        
    }
}

pub fn contar_um_status(lista_insc: List(Inscricao), status: Status) -> Int {
    case lista_insc {
        [] -> 0
        [primeiro, ..resto] if primeiro.status_pagamento == status -> 1 + contar_um_status(resto, status)
        [primeiro, ..resto] -> contar_um_status(resto, status)
    }
}

pub fn contar_todos_status(lista_insc: List(Inscricao)) -> String {
    contar_todos_status_aux(lista_insc, 0, 0, 0)
}

pub fn contar_todos_status_aux(lista_insc: List(Inscricao), concluido: Int, cancelado: Int, pendente: Int) -> String {
    case lista_insc {
        [] -> "Concluído: " <> int.to_string(concluido) <> "\nCancelado: " <> int.to_string(cancelado) <> "\nPendente: " <> int.to_string(pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Concluido -> contar_todos_status_aux(resto, concluido + 1, cancelado, pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Cancelado -> contar_todos_status_aux(resto, concluido, cancelado + 1, pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Pendente -> contar_todos_status_aux(resto, concluido, cancelado, pendente + 1)
        [_, ..] -> ""
    }
}

pub fn percentual_concluidas(lista_insc: List(Inscricao)) -> Float {

}

pub fn main() {
    let lista_insc: List(Inscricao) = [Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"), Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]

    let lista_insc: List(Inscricao) = atualizar_status_pagamento(lista_insc, 2, Concluido)
    io.println(contar_todos_status(lista_insc))
    io.debug(contar_um_status(lista_insc, Pendente))
    io.debug(verifica_id(lista_insc, 4))
    io.debug(adicionar_inscricao(lista_insc, criar_inscricao(lista_insc, 4, "a", "b", "c", Concluido, "d" )))
}

