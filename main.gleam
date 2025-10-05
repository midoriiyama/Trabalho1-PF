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

pub type InscricaoErro {
    InscricaoInvalida
}

///A partir dos dados para criar uma nova inscrição, chama a função "verifica_id()".
///Se True, a inscrição é criada e retorna como Result, senão, produz um Erro.
pub fn criar_inscricao(lista_insc: List(Inscricao), id: Int, nome_atividade: String, descricao: String, nome_participante: String, status_pagamento: Status, data: String) -> Result(Inscricao, InscricaoErro) {
    case verifica_id(lista_insc, id) {
        True -> Ok(Inscricao(id, nome_atividade, descricao, nome_participante, status_pagamento, data))
        False -> Error(InscricaoInvalida)
    }
}

///A função verifica na lista de inscrição se já existe alguma inscrição com id equivalente ao "novo_id".
///Produz True se o "novo_id" não está na lista e False se já estiver na lista.
pub fn verifica_id(lista_insc: List(Inscricao), novo_id: Int) -> Bool {
    case lista_insc {
        [] -> True
        [primeiro, ..resto] if primeiro.id == novo_id -> False
        [primeiro, ..resto] -> verifica_id(resto, novo_id)
    }
}

///A função adiciona na lista de inscrição uma inscrição e produz uma nova lista de inscrição.
pub fn adicionar_na_lista(lista_insc: List(Inscricao), inscricao: Inscricao) -> List(Inscricao) {
    let lista: List(Inscricao) = [inscricao]
    list.append(lista_insc, lista)
}

///A partir do resultado da função "criar_inscricao()", a função adiciona ou não a nova inscrição,
///produzindo uma nova lista modificada ou retornando a mesma lista sem modificações.
pub fn adicionar_inscricao(lista_insc: List(Inscricao), id: Int, nome_atividade: String, descricao: String, nome_participante: String, status_pagamento: Status, data: String) -> List(Inscricao) {
    let resultado = criar_inscricao(lista_insc, id, nome_atividade, descricao, nome_participante, Concluido, data)
    let nova_inscricao = case resultado {
        Ok(inscricao) -> adicionar_na_lista(lista_insc, inscricao)
        Error(erro) -> lista_insc
    }
}

///A função atualiza o status da inscrição que possui o "id", para o "novo_status" e produz
///a nova lista com o status modificado.
pub fn atualizar_status_pagamento(lista_insc: List(Inscricao), id: Int, novo_status: Status) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.id == id -> {
            let inscricao: List(Inscricao) = [Inscricao(primeiro.id, primeiro.nome_atividade, primeiro.descricao, primeiro.nome_participante, novo_status, primeiro.data)]
            list.append(inscricao, resto)
        }
        [primeiro, ..resto] -> [primeiro, ..atualizar_status_pagamento(resto, id, novo_status)]
    }
}

///A partir de um Status - Concluido, Cancelado, Pendente - a função produz uma lista com as inscrições
///que possuem status equivalente ao "status".
pub fn filtrar_por_status(lista_insc: List(Inscricao), status: Status) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.status_pagamento != status -> filtrar_por_status(resto, status)
        [primeiro, ..resto] -> [primeiro, ..filtrar_por_status(resto, status)]
    }
}

///A partir de uma lista de incrição, a função produz uma nova lista de inscrições sem
///as inscrições que possuem o status "Concluido"
pub fn remover_concluidos(lista_insc: List(Inscricao)) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.status_pagamento == Concluido -> remover_concluidos(resto)
        [primeiro, ..resto] -> [primeiro, ..remover_concluidos(resto)]
        
    }
}

///A partir de uma lista de incrição, a função produz uma nova lista de inscrições sem
///as inscrições que possuem o status "Cancelado"
pub fn remover_cancelados(lista_insc: List(Inscricao)) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.status_pagamento == Cancelado -> remover_cancelados(resto)
        [primeiro, ..resto] -> [primeiro, ..remover_cancelados(resto)]
        
    }
}

///A partir de uma lista de inscrição, a função produz o número de inscrições que possuem status
///correspondente ao determinado "status".
pub fn contar_um_status(lista_insc: List(Inscricao), status: Status) -> Int {
    case lista_insc {
        [] -> 0
        [primeiro, ..resto] if primeiro.status_pagamento == status -> 1 + contar_um_status(resto, status)
        [primeiro, ..resto] -> contar_um_status(resto, status)
    }
}

///A função chama a função auxiliar "contar_todos_status_aux()", a inicializando com valores nulos.
///Produz o resultado em String da função auxiliar.
pub fn contar_todos_status(lista_insc: List(Inscricao)) -> String {
    contar_todos_status_aux(lista_insc, 0, 0, 0)
}

///A partir de uma lista de inscrições, a função produz uma String que retorna a quantidade de inscrições
///que possuem os status: Concluido, Cancelado e Pendente.
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
    let lista_insc2: List(Inscricao) = adicionar_inscricao(lista_insc, 4, "a", "b", "c", Cancelado, "d")
    io.debug(lista_insc3)

}

