function [st,vt]=acelera(txacc,st,vt)

global Rv t pcar paux rend vel pos acel Fmt Ptrem v1t v2t acc dcc mt delta_t Ft A B C Framp Fcurva;
%a taxa de aceleracao nominal e de 1,12m/s2
%porem pode assumir valores menores de acordo com o ND (nivel de desempenho)
%recebido pelo trem quando parado na estacao:
%seu valor pode ser de 63% ou 50% em relacao a nominal (txacc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%evento de aceleracao
acc_max=acc*txacc; %aceleracao comandada ao trem
Rv=6*((A+(B*vt*3.6)+(C*vt*vt*3.6*3.6))*pcar); %forca resistente ao movimento em N (formula de Davis)
Framp=rampa(st);             %verifica se trem em rampa
Fcurva=curva(st);            %verifica se trem em curva
Fr=Rv+Framp+Fcurva;          %somatoria das forcas resistentes
if vt<v1t %regiao de forca constante
    Fma=Ft;
    acc_com=(Fma-Fr)/mt;
else
    if vt<v2t %regiao de potencia constante
        Fma=Ft*v1t/vt;
        acc_com=(Fma-Fr)/mt;
    else %regiao de potencia reduzida
        Fma=(Ft*v1t*v2t)/(vt*vt);
        acc_com=(Fma-Fr)/mt;
    end
end
if acc_com>=acc_max %caso a aceleracao tenha reducao de desempenho
    acc_com=acc_max;
    Fma=(acc_max*mt)+Fr;
end
vt=vt+(acc_com*delta_t); %atualizacao da velocidade (v=v0+a.delta_t) delta_t=1s
st=st+((vt*delta_t)+(0.5*acc_com*delta_t*delta_t)); %atualizacao do espaco
acel(t)=acc_com;     %variavel final de aceleracao em m/s2
vel(t)=vt;           %variavel final de velocidade em m/s
pos(t)=st;           %variavel final de posicao em m
Fmt(t)=Fma;                   %variavel final de forca matriz em N
Ptrem(t)=-(Fma*vt/rend)-paux;   %variavel final de potencia eletrica
return
