global t pcar rend paux rfr tam_plat Ptrem pos vel acel Fmt vmn redc diam;
global v1f v1t v2t acc dcc mt delta_t Ft Ff A B C num_est ne tt tf vpct vpcf;
global t S P m_via Pot pos ntrem Framp Fcurva tam_plat;
global coord_ramp inclina_ramp coord_curva forca_curva;
global ext_linha vte est loc mta;
pkg load io;              %carrega pacote para ler arquivo excel com parametros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Deslocamento do trem padrao ao longo da Linha %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%comeco do movimento%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=loc_est(1)+tam_plat(1)/2;%comeco da posicao (sempre apos a localizacao da primeira antena
vt=0;                       %comeco da velocidade
loc=0;                      %comeco do indice da antena
est=1;                      %comeco da estacao
t=1;                        %comeco do tempo
estado=0;                   %comeco do estado do trem (parado)
int_rampa=1;                %contagem da entrada na rotina de rampa
int_curva=1;                %contagem da entrada na rotina de curva
mta=xlsread(arquivo,'antenas','e2:e1000');      %vetor com marco topografico das antenas
vca=xlsread(arquivo,'antenas','f2:f1000');      %vetor com velocidade comandada pelas antenas
app=xlsread(arquivo,'antenas','c2:c1000');      %vetor com condicao da antena (parada programada em estacao ou nao)
txacc=xlsread(arquivo,'antenas','g2:g1000');    %vetor com taxa de reducao de aceleracao
txdcc=xlsread(arquivo,'antenas','h2:h1000');    %vetor com taxa de reducao de desaceleracao
temp_plat=xlsread(arquivo,'antenas','j2:j1000');%vetor com tempo em que trem fica parado em cada estacao

%calculo das constantes de Davis para resistencia ao movimento
A=xlsread(arquivo,'davis','b2');%constante Davis (peso em ton)
B=xlsread(arquivo,'davis','b3');%constante Davis
C=xlsread(arquivo,'davis','b4');%constante Davis (peso em ton)

%calculo das velocidades v1 e v2 na curva forca trativa
%v1 e a velocidade nominal dos motores de tracao
%portanto sao pegos valores nominais para seu calculo (Pires, p.148)
%v2 e a velocidade onde comeca a potencia reduzida (Pires, p. 150)
Ft=(tt*redc)/(diam/2000)*ne;       %forca trativa em velocidade baixa (N)
Ff=-(tf*redc)/(diam/2000)*ne;      %forca frenante em velocidade baixa (N)
v1t=2*pi*diam/2000*(vpct/60)/redc; %velocidade de potencia maxima tracao (m/s)
v2t=1.7*v1t;                       %velocidade final de potencia constante(m/s)
v1f=2*pi*diam/2000*(vpcf/60)/redc; %velocidade de potencia maxima freio (m/s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rotina ocorre enquanto trem vai e volta pela extensao da linha
while st<mta(end)
    locantes=loc;                              %variavel auxiliar de troca de antena
    est=find(loc_est>st)(1)-1;                 %indica qual a ultima estacao pela qual o trem passou
    loc=find(mta>st)(1)-1;                     %indice da ultima antena que o trem passou
    pcar=(((mv*(1+txr))+(txc(est)*mc))/6000)*9.80665;%peso de um carro saindo da estacao (em kN) - todos carros com peso igualmente distribuido
    mt=(mv*(1+txr))+(txc(est)*mc);             %calculo da massa final do trem (kg)
    if locantes~=loc                           %trem mudou de antena
        vte=vt;                                %velocidade de entrada na antena
        if vt<vca(loc)                         %velocidade do trem menor que a comandada pela antena
            estado=1;                          %estado de aceleracao
        elseif vt>vca(loc)                     %velocidade do trem maior que a comandada pela antena
            estado=2;                          %estado de desaceleracao
        elseif vt==vca(loc)                    %velocidade do trem igual a comandada pela antena
            estado=3;                          %estado de velocidade constante
        end
    end
    if vt<vca(loc) && estado==1            %velocidade do trem menor que a comandada pela antena
        [st,vt]=acelera(txacc(loc),st,vt); %rotina de aceleracao
    elseif (vt>=vca(loc) && estado==1) || (vt<=vca(loc) && estado==2) || (estado==3) %velocidade maior ou igual e acelerando; ou menor ou igual e freando; ou igual
        [st,vt]=constante(st,vt);          %rotina de velocidade constante
    elseif vt>vca(loc) && estado==2        %velocidade do trem maior que a comandada pela antena
        [st,vt]=desacelera(app(loc),txdcc(loc),st,vt);%rotina de desaceleracao
    end
    if app(loc)==1 && vt==0                    %trem parado em estacao (apos ter passado por antena de pp)
        parado(st,vt,temp_plat(loc));          %rotina de trem parado pelo tempo programado na plataforma
    end
    antena(t)=loc;
    estacao(t)=est;
    fcurva(t)=Fcurva;
    frampa(t)=Framp;
    t=t+1;
end
t=t-1; %ajuste do tempo final para entrada nas proximas etapas de simulacao
