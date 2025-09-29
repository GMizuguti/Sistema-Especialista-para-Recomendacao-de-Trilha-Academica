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
