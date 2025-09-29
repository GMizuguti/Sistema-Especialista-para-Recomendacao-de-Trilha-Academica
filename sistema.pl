% trilha(Trilha, Descricao)
% perfil(Trilha, Interesse, Peso)

% definindo trilhas e descricoes

trilha(desenvolvimento_jogos, 'Desenvolvimento de Jogos! Crie experiencias interativas em 2D e 3D, unindo criatividade, design e programacao!').
    perfil(desenvolvimento_jogos, planejamento, 2).
    perfil(desenvolvimento_jogos, design_grafico, 2).
    perfil(desenvolvimento_jogos, jogos, 5).
    perfil(desenvolvimento_jogos, criatividade, 5).
    perfil(desenvolvimento_jogos, programacao_baixo_nivel, 1).

trilha(robotica, 'Robotica! Desenvolva sistemas inteligentes que unem mecanica, eletronica e programacao para automacao e inovacao!').
    perfil(robotica, pratica, 4).
    perfil(robotica, programacao_baixo_nivel, 4).
    perfil(robotica, mecanica, 5).
    perfil(robotica, criatividade, 3).
    perfil(robotica, otimizacao, 2).

trilha(neurotecnologia, 'Neurotecnologia! Explore a interface entre o cerebro humano e dispositivos tecnologicos para saude e inovacao!').
    perfil(neurotecnologia, pratica, 2).
    perfil(neurotecnologia, pesquisa_academica, 3).
    perfil(neurotecnologia, biologia, 5).
    perfil(neurotecnologia, inovador, 5).

trilha(gestao_projetos, 'Gestao de Projetos! Planeje, organize e lidere equipes para alcancar resultados de forma eficiente!').
    perfil(gestao_projetos, planejamento, 4).
    perfil(gestao_projetos, lideranca, 5).
    perfil(gestao_projetos, metodologias_ageis, 5).
    perfil(gestao_projetos, pratica, 2).

trilha(desenvolvimento_mobile, 'Desenvolvimento Mobile! Crie aplicativos para Android e iOS, unindo design e experiencia de usuario!').
    perfil(desenvolvimento_mobile, mobile, 5).
    perfil(desenvolvimento_mobile, design_grafico, 4).
    perfil(desenvolvimento_mobile, otimizacao, 4).
    perfil(desenvolvimento_mobile, criatividade, 3).





% pergunta(IdPergunta, Enunciado, Interesse)
% pergunta contem um identificador, o enunciado da pergunta e o interesse associado a pergunta

pergunta(1, '1. Voce e uma pessoa sistematica? (s/n)', planejamento).

pergunta(2, '2. Voce e uma pessoa sociavel e proativa? (s/n)', lideranca).

pergunta(3, '3. Voce gosta de trabalhos artisticos? (s/n)', criatividade).

pergunta(4, '4. Voce se tem um carinho especial por videogames? (s/n)', jogos).

pergunta(5, '5. Voce tem fascinio pelo funcionamento de maquinas? (s/n)', mecanica).

pergunta(6, '6. Voce se importa em excesso com desempenho e tirar o maximo de proveito de algo? (s/n)', otimizacao).

pergunta(7, '7. Por a mao na massa e algo importante para voce? (s/n)', pratica).

pergunta(8, '8. Desenvolver para plataformas mobile e algo que te interessa? (s/n)', mobile).

pergunta(9, '9. Produtividade, proatividade e agilidade sao pontos fortes seus? (s/n)', metodologias_ageis).

pergunta(10, '10. A ideia de entender e observar o funcionamento do cerebro te cativa? (s/n)', biologia).

pergunta(11, '11. Escrever e publicar artigos sobre aquilo que voce trabalhou te empolga? (s/n)', pesquisa_academica).

pergunta(12, '12. As cores, formas e disposicoes da interface que voce criou foram feitas com um carinho que nem todos vao perceber? (s/n)', design_grafico).

pergunta(13, '13. Estar na bleeding edge da sua area te anima? (s/n)', inovador).

pergunta(14, '14. Programar e estudar as minuncias de assembly soa como entretenimento? (s/n)', programacao_baixo_nivel).


:- dynamic resposta/2.  % informa o interpretador que a definicao do predicado talvez mude durante a execucao

% "conversor"
valor(s,1). % toda variavel que contem o atomo s tera o valor 1
valor(n,0). % toda variavel que contem o atomo n tera o valor 0



iniciar :-                          % predicado principal parar iniciar modo interativo
    retractall(resposta(_, _)),     % limpa respostas anteriores
    faz_perguntas,                  % inicia o questionario
    recomenda(Recomendacao),        % calcula as pontuacoes de cada trilha e organiza em ordem decrescente 
    exibe_resultado(Recomendacao).  % exibe as 3 trilhas mais recomendadas para o perfil do usuario

iniciar_teste_perfil(Arquivo) :-    % predicado principal para iniciar modo teste de perfil
    retractall(resposta(_, _)),     % limpa respostas anteriores
    consult(Arquivo),               % carrega o arquivo de perfil com as respostas pre-definidas
    recomenda(Recomendacao),        % calcula as pontuacoes de cada trilha e organiza em ordem decrescente
    exibe_resultado(Recomendacao).  % exibe as 3 trilhas mais adequadas para o perfil carregado
    

faz_perguntas :-                                % predicado que faz as perguntas ao usuario
    forall(pergunta(IdPergunta, Enunciado, _),  % "loop foreach", para cada pergunta definida:
        ( format('~w :', [Enunciado]),          % exibir o enunciado da pergunta
        read(Resposta),                         % ler a resposta do usuario
        assertz(resposta(IdPergunta, Resposta)) % armazenar a resposta no banco de fatos
        )).


% predicado para chamar calculo da pontuacao de todas as trilhas, e organizar em ordem decrescente pela pontuacao e "retornar" a lista organizada
recomenda(ResultadosOrganizados) :-             
    findall((Trilha, Pontuacao),                    % encontra as trilhas e suas pontuacoes, e cria uma lista de tuplas (Trilha, Pontuacao)
            ( trilha(Trilha, _),                    % para cada trilha definida
              calcula_pontuacao(Trilha, Pontuacao)  % chama predicado que calcula a pontuacao da trilha
            ),
            Tuplas),                                % armazena a tupla na lista Tuplas
    sort(2, @>=, Tuplas, ResultadosOrganizados).    % ordena a lista Tuplas pela segunda posicao (pontuacao) em ordem decrescente e armazena em ResultadosOrganizados



calcula_pontuacao(Trilha, Pontuacao) :-                 % predicado para calcular a pontuacao de uma trilha, recebe a trilha e "retorna" a pontuacao
    findall(PesoResp,(                                  % encontra o peso da resposta de cada pergunta relevante da trilha atual e atribui a variavel PesoResp, depois guarda na lista ListaPesos
                    perfil(Trilha, Interesse, Peso),    % para cada perfil associado a trilha, pega o Interesse
                    pergunta(IdPergunta, _, Interesse), % encontra a pergunta associada ao interesse
                    resposta(IdPergunta, Resposta),     % pega a resposta dessa pergunta
                    valor(Resposta, V),                 % "converte" a resposta 1/0 e armazena em V
                    PesoResp is Peso * V                % calcula o peso da resposta e atribui a PesoResp
                    ),
            ListaPesos),                                % armazena os pesos na lista ListaPesos
    sum_list(ListaPesos, Pontuacao).                    % soma os pesos da lista e atribui a Pontuacao



    
% predicado para exibir o resultado final, recebe a lista de trilhas ja organizada de forma decrescente pela pontuacao
exibe_resultado(ResultadosOrganizados) :-                                                           
    writeln("\n\n-------As 3 Trilhas mais Recomendadas para o seu perfil-------\n"),
    ResultadosOrganizados = [(Trilha1,Pontuacao1),(Trilha2,Pontuacao2),(Trilha3,Pontuacao3)|_], % pega as 3 primeiras tuplas da lista e atribui os elementos das tuplas a variaveis

    trilha(Trilha1, Descricao1),                                % busca a trilha e a descricao referente a Trilha1
    writeln("-------Primeiro lugar-------\n"),                  
    format("1) ~w (~w pontos)~n", [Descricao1, Pontuacao1]),
    writeln("Perguntas que te trouxeram a essa trilha:\n"),
    forall(resposta(Id1, s),                                    % "foreach", para todas as respostas "s": 
        ( pergunta(Id1, Enunciado1, _),                         % buscar a pergunta associada a resposta pelo Id
          format("~w -> s~n \n", [Enunciado1])                  % exibir a pergunta e a resposta "s"
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

