import gleam/io
import sgleam/check
import gleam/int
import gleam/list
import gleam/float

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
    IdJaExiste
}

///A partir dos dados para criar uma nova inscrição, chama a função "verifica_id()".
///Se True, a inscrição é criada e retorna como Result, senão, produz um Erro.
pub fn criar_inscricao(lista_insc: List(Inscricao), id: Int, nome_atividade: String, descricao: String, nome_participante: String, status_pagamento: Status, data: String) -> Result(Inscricao, InscricaoErro) {
    case verifica_id(lista_insc, id) {
        True -> Ok(Inscricao(id, nome_atividade, descricao, nome_participante, status_pagamento, data))
        False -> Error(IdJaExiste)
    }
}

pub fn criar_inscricao_ex() {
    ///A lista_insc possui incrições com os ids 0, 1, 2, 3.
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(criar_inscricao(lista_insc, 4, "a", "b", "c", Pendente, "d"), Ok(Inscricao(4, "a", "b", "c", Pendente, "d")))
    check.eq(criar_inscricao(lista_insc, 3, "a", "b", "c", Pendente, "d"), Error(IdJaExiste))
}

///A função verifica na lista de inscrição se já existe alguma inscrição com id equivalente ao "novo_id".
///Produz True se o "novo_id" não está na lista e False se já estiver na lista.
pub fn verifica_id(lista_insc: List(Inscricao), novo_id: Int) -> Bool {
    case lista_insc {
        [] -> True
        [primeiro, ..resto] if primeiro.id == novo_id -> False
        [primeiro, ..resto] if novo_id < 0 -> False
        [primeiro, ..resto] -> verifica_id(resto, novo_id)
    }
}

pub fn verifica_id_ex() {
    ///A lista_insc possui incrições com os ids 0, 1, 2, 3.
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(verifica_id([], 3), True)
    check.eq(verifica_id(lista_insc, 4), True)
    check.eq(verifica_id(lista_insc, 2), False)
    check.eq(verifica_id(lista_insc, -1), False)
}

///A função adiciona na lista de inscrição uma inscrição e produz uma nova lista de inscrição.
pub fn adicionar_na_lista(lista_insc: List(Inscricao), inscricao: Inscricao) -> List(Inscricao) {
    let lista: List(Inscricao) = [inscricao]
    list.append(lista_insc, lista)
}

pub fn adicionar_na_lista_ex() {
    ///A lista_insc possui inscrições com os ids 0, 1, 2, 3:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    let insc: Inscricao = Inscricao(4, "a", "b", "c", Pendente, "d")
    check.eq(adicionar_na_lista(lista_insc, insc), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                    Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                    Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                                    Inscricao(3, "a", "b", "c", Pendente, "d"),
                                                    Inscricao(4, "a", "b", "c", Pendente, "d")])
}

///A função que deve ser chamada para criar e adicionar uma nova inscrição.
///A partir do resultado da função "criar_inscricao()", a função adiciona ou não a nova inscrição,
///produzindo uma nova lista modificada ou retornando a mesma lista sem modificações.
pub fn adicionar_inscricao(lista_insc: List(Inscricao), id: Int, nome_atividade: String, descricao: String, nome_participante: String, status_pagamento: Status, data: String) -> List(Inscricao) {
    let resultado = criar_inscricao(lista_insc, id, nome_atividade, descricao, nome_participante, status_pagamento, data)
    case resultado {
        Ok(inscricao) -> {  io.println("\nInscrição com id '" <> int.to_string(id) <> "' adicionada com sucesso!")
                            adicionar_na_lista(lista_insc, inscricao)}
        Error(erro) -> { io.print("\nErro ao adicionar inscrição com id '" <> int.to_string(id) <> "'")
                         io.debug(erro)
                         lista_insc}
    }
}

pub fn adicionar_inscricao_ex() {
    ///A lista_insc possui inscrições com os ids 0, 1, 2, 3:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(adicionar_inscricao(lista_insc, 4, "a", "b", "c", Pendente, "d"), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                                                Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                                                Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                                                                Inscricao(3, "a", "b", "c", Pendente, "d"),
                                                                                Inscricao(4, "a", "b", "c", Pendente, "d")])

    check.eq(adicionar_inscricao(lista_insc, 3, "a", "b", "c", Pendente, "d"), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                                                Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                                                Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                                                                Inscricao(3, "a", "b", "c", Pendente, "d")])
}


///A função atualiza o status da inscrição que possui o "id", para o "novo_status" e produz
///a nova lista com o status modificado.
pub fn atualizar_status_pagamento(lista_insc: List(Inscricao), id: Int, novo_status: Status) -> List(Inscricao) {
    case lista_insc {
        [] -> []
        [primeiro, ..resto] if primeiro.id == id -> {
            io.println("\nStatus de pagamento da Inscrição '" <> int.to_string(id) <>"' atualizado com sucesso!")
            let inscricao: List(Inscricao) = [Inscricao(primeiro.id, primeiro.nome_atividade, primeiro.descricao, primeiro.nome_participante, novo_status, primeiro.data)]
            list.append(inscricao, resto)
        }
        [primeiro, ..resto] -> [primeiro, ..atualizar_status_pagamento(resto, id, novo_status)]
    }
}

pub fn atualizar_status_pagamento_ex() {
    ///A lista_insc possui inscrições com os ids 0, 1, 2, 3:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(atualizar_status_pagamento(lista_insc, 3, Cancelado), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                                                    Inscricao(3, "a", "b", "c", Cancelado, "d")])

    check.eq(atualizar_status_pagamento(lista_insc, 2, Concluido), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(2, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(3, "a", "b", "c", Pendente, "d")])
                                                                
    check.eq(atualizar_status_pagamento(lista_insc, 0, Pendente), [Inscricao(0, "a", "b", "c", Pendente, "d"),
                                                                    Inscricao(1, "a", "b", "c", Concluido, "d"),
                                                                    Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                                                    Inscricao(3, "a", "b", "c", Pendente, "d")])
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

pub fn filtrar_por_status_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(filtrar_por_status(lista_insc, Concluido), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                                         Inscricao(1, "a", "b", "c", Concluido, "d")])
    check.eq(filtrar_por_status(lista_insc, Pendente), [Inscricao(3, "a", "b", "c", Pendente, "d")])
    check.eq(filtrar_por_status(lista_insc, Cancelado), [Inscricao(2, "a", "b", "c", Cancelado, "d")])
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

pub fn remover_concluidos_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(remover_concluidos(lista_insc), [Inscricao(2, "a", "b", "c", Cancelado, "d"),
                                              Inscricao(3, "a", "b", "c", Pendente, "d")])
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

pub fn remover_cancelados_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(remover_cancelados(lista_insc), [Inscricao(0, "a", "b", "c", Concluido, "d"),
                                              Inscricao(1, "a", "b", "c", Concluido, "d"),
                                              Inscricao(3, "a", "b", "c", Pendente, "d")])
}

///A partir de uma lista de inscrição, a função produz o número de inscrições que possuem status
///correspondente ao determinado "status".
pub fn contar_um_status(lista_insc: List(Inscricao), status: Status) -> Int {
    case lista_insc {
        [] -> 0
        [primeiro, ..resto] if primeiro.status_pagamento == status -> 1 + contar_um_status(resto, status)
        [_, ..resto] -> contar_um_status(resto, status)
    }
}

pub fn contar_um_status_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(contar_um_status(lista_insc, Concluido), 2)
    check.eq(contar_um_status(lista_insc, Pendente), 1)
    check.eq(contar_um_status(lista_insc, Cancelado), 1)
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
        [] -> "\nConcluído: " <> int.to_string(concluido) <> "\nCancelado: " <> int.to_string(cancelado) <> "\nPendente: " <> int.to_string(pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Concluido -> contar_todos_status_aux(resto, concluido + 1, cancelado, pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Cancelado -> contar_todos_status_aux(resto, concluido, cancelado + 1, pendente)
        [primeiro, ..resto] if primeiro.status_pagamento == Pendente -> contar_todos_status_aux(resto, concluido, cancelado, pendente + 1)
        [_, ..] -> ""
    }
}

pub fn contar_todos_status_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(contar_todos_status(lista_insc), "Concluído: 2\nCancelado: 1\nPendente: 1")
}

pub fn percentual_concluidas(lista_insc: List(Inscricao)) -> Float {
    case list.length(lista_insc) > 0 {
        True -> float.to_precision(int.to_float(contar_um_status(lista_insc, Concluido)) /. int.to_float(list.length(lista_insc)) *. 100.0, 2)
        False -> 0.0
    }
}

pub fn percentual_concluidas_ex() {
    ///lista_insc:
    ///[Inscricao(0, "a", "b", "c", Concluido, "d"), Inscricao(1, "a", "b", "c", Concluido, "d"),
    /// Inscricao(2, "a", "b", "c", Cancelado, "d"), Inscricao(3, "a", "b", "c", Pendente, "d")]
    let lista_insc: List(Inscricao) = lista_inscricoes()
    check.eq(percentual_concluidas(lista_insc), 33.33)
    check.eq(percentual_concluidas([]), 0.0)

}

fn lista_inscricoes() -> List(Inscricao) {
    [Inscricao(0, "a", "b", "c", Concluido, "d"),
     Inscricao(1, "a", "b", "c", Concluido, "d"),
     Inscricao(2, "a", "b", "c", Cancelado, "d"),
     Inscricao(3, "a", "b", "c", Pendente, "d")]
}


pub fn main() {

    let l1: List(Inscricao) = []
    let l2: List(Inscricao) = adicionar_inscricao(l1, 0, "Festa", "Festa de Debutante da Isa", "Isabella", Pendente, "21/10/2026")
    let l3: List(Inscricao) = adicionar_inscricao(l2, 0, "Festa", "Festa de Aniversário", "João", Pendente, "27/02/2026")
    let l4: List(Inscricao) = adicionar_inscricao(l3, 1, "Festa", "Festa de Aniversário", "Maria", Pendente, "20/12/2026")
    let l5: List(Inscricao) = adicionar_inscricao(l4, 2, "Festa", "Festa de Casamento", "Akemi", Pendente, "02/07/2026")
    let l6: List(Inscricao) = adicionar_inscricao(l5, 3, "Festa", "Festa de Despedida de Solteiro", "Pedro", Pendente, "27/12/2026")
    io.println(contar_todos_status(l6))
    let l7: List(Inscricao) = atualizar_status_pagamento(l6, 2, Concluido)
    let l8: List(Inscricao) = atualizar_status_pagamento(l7, 1, Cancelado)
    io.println(contar_todos_status(l8))
    let l_pendente: List(Inscricao) = filtrar_por_status(l8, Pendente)
    let l_concluido: List(Inscricao) = filtrar_por_status(l8, Concluido)
    let l_cancelado: List(Inscricao) = filtrar_por_status(l8, Cancelado)
    io.print("\n")
    io.debug(l_pendente)
    io.debug(l_concluido)
    io.debug(l_cancelado)
    let l9: List(Inscricao) = remover_cancelados(l8)
    io.println(contar_todos_status(l9))
    let l10: List(Inscricao) = remover_concluidos(l9)
    io.println(contar_todos_status(l10))
    io.debug(contar_um_status(l10, Concluido))
    io.debug(contar_um_status(l10, Cancelado))
    io.debug(contar_um_status(l10, Pendente))
    io.debug(percentual_concluidas(l9))


    

    ///Testes Ex:
    //io.debug(criar_inscricao_ex())
    //io.debug(verifica_id_ex())
    //io.debug(adicionar_na_lista_ex())
    //io.debug(adicionar_inscricao_ex())
    //io.debug(atualizar_status_pagamento_ex())
    //io.debug(filtrar_por_status_ex())
    //io.debug(remover_cancelados_ex())
    //io.debug(remover_concluidos_ex())
    //io.debug(contar_um_status_ex())
    //io.debug(contar_todos_status_ex())
}

