function [st,vt]=desacelera(app,txdcc,st,vt)

global t pcar paux tam_plat rend vel pos acel Fmt Ptrem v1f vte;
global acc dcc mt delta_t Ff A B C Framp Fcurva tam_plat est loc mta;

%a desaceleracao se da em duas condicoes:
%1- em troca de codigo de via ao longo do percurso:
%nessa condicao, sera assumido que a taxa de desaceleracao sera a nominal
%2- em parada programada nas estacoes:
%desacelera desde a antena ate a total parada no final da plataforma
%com taxa de desaceleracao necessaria para tal
%dada a taxa de desaceleracao e a posicao da antena:
%em caso de parada programa na estacao (pp==1): desacelera com taxa necessaria
%para que tenha velocidade zero no final da plataforma (antena localizada no comeco da plataforma)
%em caso de trasicao de codigo (pp==0), desacelera em taxa nominal a partir da
%posicao dada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rv=6*((A+(B*vt*3.6)+(C*vt*vt*3.6*3.6))*pcar); %forca resistente ao movimento em N (formula de Davis)
Framp=rampa(st);                 %verifica se trem em rampa
Fcurva=curva(st);                %verifica se trem em curva
Fr=Rv+Framp+Fcurva;              %somatoria das forcas resistentes
if app==0                         %evento de desaceleracao no meio do percurso
    dcc_max=-txdcc*dcc; %desac. nominal vezes fator, caso reducao no meio do caminho
    if vt<v1f %regiao de forca constante
        Fma=Ff;
        dcc_com=(Fma-Fr)/mt;
    else %regiao de potencia constante
        Fma=(Ff*v1f)/vt;
        dcc_com=(Fma-Fr)/mt;
    end
    if dcc_com<=dcc_max %caso a desaceleracao tenha reducao de desempenho
        dcc_com=dcc_max;
        %Fma=Ff; %codigo para possibilitar a plotagem da forca frenante (somente)
        Fma=(dcc_max*mt)+Fr;
    end
    vt=vt+(dcc_com*delta_t);     %atualizacao da velocidade (v=v0+a.delta_t) delta_t=1s
    if vt<0                      %zerar a velocidade em caso de velocidades muito baixas
        vt=0;
    end
    st=st+((vt*delta_t)+(0.5*dcc_com*delta_t*delta_t)); %atualizacao do espaco
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif app==1                     %evento de desaceleracao em parada programada
    dcc_com=-(vte*vte)/(2*tam_plat(est+1));%calculo da aceleracao necessaria para trem parar ao final da plataforma
    Fma=(dcc_com*mt)+Fr;
    vt=vt+(dcc_com*delta_t);     %atualizacao da velocidade (v=v0+a.delta_t) delta_t=1s
    st=st+((vt*delta_t)+(0.5*dcc_com*delta_t*delta_t)); %atualizacao do espaco
    if vt<0 || st>=mta(loc+1)    %zerar a velocidade e arrumar posicao na pp
        vt=0;
        st=mta(loc+1);
    end
end
acel(t)=dcc_com;                %variavel final de aceleracao em m/s2
vel(t)=vt;                      %variavel final de velocidade em m/s
pos(t)=st;                      %variavel final de posicao em m
Fmt(t)=Fma;                     %variavel final de forca motriz em N
Ptrem(t)=-(Fma*vt*rend)-paux;   %variavel final de potencia eletrica
return
