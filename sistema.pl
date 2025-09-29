% trilha(Trilha, Descricao)
% perfil(Trilha, Interesse, Peso)

trilha(desenvolvimento_jogos, 'Desenvolvimento de Jogos! Crie experiencias interativas em 2D e 3D, unindo criatividade, design e programacao.').
    perfil(desenvolvimento_jogos, planejamento, 2).
    perfil(desenvolvimento_jogos, design_grafico, 2).
    perfil(desenvolvimento_jogos, jogos, 5).
    perfil(desenvolvimento_jogos, criatividade, 5).
    perfil(desenvolvimento_jogos, programacao_baixo_nivel, 1).

trilha(robotica, 'Robotica! Desenvolva sistemas inteligentes que unem mecânica, eletrônica e programacao para automacao e inovacao.').
    perfil(robotica, pratica, 4).
    perfil(robotica, programacao_baixo_nivel, 4).
    perfil(robotica, mecanica, 5).
    perfil(robotica, criatividade, 3).
    perfil(robotica, otimizacao, 2).

trilha(neurotecnologia, 'Neurotecnologia! Explore a interface entre o cérebro humano e dispositivos tecnológicos para saude e inovacao.').
    perfil(neurotecnologia, pratica, 2).
    perfil(neurotecnologia, pesquisa_academica, 3).
    perfil(neurotecnologia, biologia, 5).
    perfil(neurotecnologia, inovador, 5).

trilha(gestao_projetos, 'Gestao de Projetos! Planeje, organize e lidere equipes para alcançar resultados de forma eficiente.').
    perfil(gestao_projetos, planejamento, 4).
    perfil(gestao_projetos, lideranca, 5).
    perfil(gestao_projetos, metodologias_ageis, 5).
    perfil(gestao_projetos, pratica, 2).

trilha(desenvolvimento_mobile, 'Desenvolvimento Mobile! Crie aplicativos para Android e iOS, unindo design e experiencia de usuario.').
    perfil(desenvolvimento_mobile, mobile, 5).
    perfil(desenvolvimento_mobile, design_grafico, 4).
    perfil(desenvolvimento_mobile, otimizacao, 4).
    perfil(desenvolvimento_mobile, criatividade, 3).





% pergunta(IdPergunta, Enunciado, Interesse)

pergunta(1, '1. Voce e uma pessoa sistematica? (s/n)', planejamento).

pergunta(2, '2. Voce e uma pessoa sociavel e proativa? (s/n)', lideranca).

pergunta(3, '3. Voce gosta de trabalhos artisticos? (s/n)', criatividade).

pergunta(4, '4. Voce se tem um carinho especial por videogames? (s/n)', jogos).

pergunta(5, '5. Voce tem fascinio pelo funcionamento de maquinas? (s/n)', mecanica).

pergunta(6, '6. Voce se importa em excesso com desempenho e tirar o maximo de proveito de algo? (s/n)', otimizacao).

pergunta(7, '7. Por a mao na massa e algo importante para voce? (s/n)', pratica).

pergunta(8, '8. Desenvolver para plataformas mobile e algo que te interessa? (s/n)', mobile).

pergunta(9, '9.Produtividade, proatividade e agilidade sao pontos fortes seus? (s/n)', metodologias_ageis).

pergunta(10, '10. A ideia de entender e observar o funcionamento do cerebro te cativa? (s/n)', biologia).

pergunta(11, '11. Escrever e publicar artigos sobre aquilo que voce trabalhou te empolga? (s/n)', pesquisa_academica).

pergunta(12, '12. As cores, formas e disposicoes da interface que voce criou foram feitas com um carinho que nem todos vao perceber? (s/n)', design_grafico).

pergunta(13, '13. Estar na bleeding edge da sua area te anima? (s/n)', inovador).

pergunta(14, '14. Programar e estudar as minuncias de assembly soa como entretenimento? (s/n)', programacao_baixo_nivel).


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
    recomenda(Recomendacao),
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

