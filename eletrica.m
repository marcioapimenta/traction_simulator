global t S Ptrafego num_trem num_ret num_arm num_cross nativos tint Un;
global imp_pos imp_neg m_via tint;
global Umin2 a Umax1 Umax2 Ud0 erro_pot cross ntrem nret narm Rret;
global ntotal vterra vground1 vground2 esttrem Veterro k eatual;

%matriz S contem posicao dos ativos. As primeiras num_trem linhas contem a posicao
%em metros de cada trem ao longo do tempo do trafego. Seguidas de num_ret linhas com
%posicao das retificadoras. Em seguida, num_arm linhas com posicao dos armazenadores.
%Em seguida, o restante de linhas com posicao dos crossbounds
%matriz Ptrafego, que tras em cada linha a potencia em watts de cada trem ao longo
%do tempo do trafego
%tempo de trafego t, em segundos, necessario para uma volta do trem no
%sistema
%matriz id de identificacao dos ativos no sistema, sendo:
%1 a ntrem: trem
%ntrem+1 a nret:subestacao retificadora
%nret+1 a narm:armazenador de energia
%narm+1 a nativos: cabos crossbound

ntrem=num_trem;                %quantidade de trens
nret=num_trem+num_ret;         %quantidade de trens+retificadoras
narm=num_trem+num_ret+num_arm; %quantidade de trens+retificadoras+armaz.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insercao de linhas de posicao das retificadoras na matriz de posicao
for j=1:num_ret
    S(ntrem+j,:)=Sret(j);
    %m_via(ntrem+j,:)=0;        %via das retificadoras==0
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo da resistencia interna e corrente de Norton dos armazenadores
%insercao de linhas de posicao e potencia dos armazenadores nas matrizes de
%entrada da simulacao eletrica
## for j=1:num_arm
##     Rarm(j)=0;            %resistencia interna
##     Iarm(j)=0;            %corrente de Norton
##     S(nret+j,:)=Sarm(j);
##     m_via(nret+j,:)=0;    %via dos armazenadores==0
## end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insercao da localizacao (marco topografico) dos cabos de crossbounds na matriz de posicao
for j=1:num_cross
    S(narm+j,:)=cross(j);
    %m_via(narm+j,:)=0;    %via dos crossbounds==0
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% ordenacao da matriz da posicao dos ativos %%%%%%%%%%%%%%%%%
%matriz Sc com posicao crescente dos ativos (cada coluna um instante)
%matriz id com indice dos ativos (cada coluna um instante)
%a matriz id serve para manter a identificacao de cada ativo, uma vez que sua
%ordem e alterada devido sua localizacao (matriz Sc)
[Sc,id]=sort(S);          %ordena em ordem crescente as colunas de S
nativos=size(Sc,1);       %numero de ativos do sistema (linhas da matriz Sc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% montagem do vetor de tensao inicial sob os ativos %%%%%%%%%%%%%%%
%a variavel vatual armazena o valor da tensao sobre cada ativo
%para o primeiro instante, todos com tensao nominal e retificadoras ligadas
for i=1:nativos
    if i<=ntrem                 %trem
        vatual(i)=Un;
    elseif i>ntrem && i<=nret   %retificadora
        vatual(i)=Un;
        Rret(i-ntrem)=((Ud0(i-ntrem)*Un)-(Un*Un))/Pret(i-ntrem);
        estret(i-ntrem)=1;
    %elseif i>nret && i<=narm  %armazenador
    else                       %crossbounds
        vatual(i)=0;
    endif
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% processo de calculo de tensao e corrente para cada instante %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%a tensao sobre cada ativo na iteracao posterior e igual a final da iteracao
%anterior, bem como o estado de cada retificadora, apenas se em algum instante
%nao ha convergencia, para o proximo, a tensao sob os ativos volta a ser a nominal
%e as retificadoras sao ligadas
iatual=zeros(1,nativos);    %carregamento do vetor de corrente dos ativos
vantes=zeros(1,nativos);    %carregamento do vetor de tensao inicial dos nos
k=1;   %variavel para armazenamento no vetor de eventual nao convergencia
for tint=1:t
    trocaest=1;  %carregamento da variavel de troca de estado de retificadora
    ntotal=0;    %carregamento do numero de iteracoes para o instante
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %enquanto houver alteracao no estado das retificadoras, iteracao continua
    while trocaest==1
        [vatual,iatual,nconv]=iteracao(Sc(:,tint)',Ptrafego(:,tint)',id(:,tint)',m_via(:,tint)',vatual,vantes,iatual);
        if nconv==1 %se houve nao convergencia, proximo passo tem como tensao inicial a nominal do sistema
            Vfinal(:,tint)=vatual';
            Ifinal(:,tint)=iativo';
            Pfinal(:,tint)=Patual';
            for i=1:nativos
                if i<=ntrem                 %trem
                    vatual(i)=Un;
                elseif i>ntrem && i<=nret   %retificadora
                    vatual(i)=Un;
                    estret(i-ntrem)=1;
                    Rret(i-ntrem)=((Ud0(i-ntrem)*Un)-(Un*Un))/Pret(i-ntrem);
                %elseif i>nret && i<=narm  %armazenador
                else
                    vatual(i)=0;
                endif
            endfor
            break
        else   %se houve convergencia, verifica se houve troca de estado das retificadoras
            [estret,iativo,trocaest]=verestret(id(:,tint)',estret,vatual,iatual);
        endif
    endwhile
    [Patual]=calculaP(vatual,iatual); %calculo da potencia eletrica nos trens
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %armazenamento das variaveis de saida do simulador
    if nconv==0
        Vfinal(:,tint)=vatual';
        Ifinal(:,tint)=iativo';
        Pfinal(:,tint)=Patual';
    endif
    Efinal(:,tint)=eatual';
    Eretificadora(:,tint)=estret';
    Etrem(:,tint)=esttrem';
    Vterra(:,tint)=vterra';
    Ntotal(tint)=ntotal;
    tint
endfor
