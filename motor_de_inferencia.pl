:- dynamic resposta/2.


valor(s,1).
valor(n,0).



iniciar :-
    retractall(resposta(_, _)),
    faz_perguntas,
    recomenda(Recomendacao),
    exibe_resultado(Recomendacao).

iniciar_teste_perfil(Arquivo) :-
    retractall(resposta(_, _)),   
    consult(Arquivo),
    definir_recomendacao(Recomendacao),
    exibe_resultado(Recomendacao).
    

faz_perguntas :-
    forall(pergunta(IdPergunta, Enunciado, _),
        ( format('~w :', [Enunciado]),
        read(Resposta),
        assertz(resposta(IdPergunta, Resposta))
        )).


recomenda(ResultadosOrganizados) :-   
    findall((Trilha, Pontuacao),
            ( trilha(Trilha, _),
              calcula_pontuacao(Trilha, Pontuacao)
            ),
            Tuplas),
    sort(2, @>=, Tuplas, ResultadosOrganizados).



calcula_pontuacao(Trilha, Pontuacao) :-
    findall(PesoResp,(
                    perfil(Trilha, Interesse, Peso),
                    pergunta(IdPergunta, _, Interesse),
                    resposta(IdPergunta, Resposta),
                    valor(Resposta, V),
                    PesoResp is Peso * V
                    ),
            ListaPesos),
    sum_list(ListaPesos, Pontuacao).



    

exibe_resultado(ResultadosOrganizados) :-
    writeln("\n\n-------As 3 Trilhas mais Recomendadas para o seu perfil-------\n"),
    ResultadosOrganizados = [(Trilha1,Pontuacao1),(Trilha2,Pontuacao2),(Trilha3,Pontuacao3)|_],

    trilha(Trilha1, Descricao1),
    writeln("-------Primeiro lugar-------\n"),
    format("1) ~w (~w pontos)~n", [Descricao1, Pontuacao1]),
    writeln("Perguntas que te trouxeram a essa trilha:\n"),
    forall(resposta(Id1, s),
        ( pergunta(Id1, Enunciado1, _),
          format("~w -> s~n \n", [Enunciado1])
        )),
    nl,

    trilha(Trilha2, Descricao2),
    writeln("\n-------Segundo lugar-------\n"),
    format("2) ~w (~w pontos)~n", [Descricao2, Pontuacao2]),
    nl,

    trilha(Trilha3, Descricao3),
    writeln("\n-------Terceiro lugar-------\n"),
    format("3) ~w (~w pontos)~n", [Descricao3, Pontuacao3]),
    nl.