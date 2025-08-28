function [st,vt]=constante(st,vt)

global Rv t pcar paux rend vel pos acel Fmt Ptrem v1t v2t acc dcc mt delta_t Ft A B C Framp Fcurva;
%a taxa de aceleracao nominal e de 1,12m/s2
%porem pode assumir valores menores de acordo com o ND (nivel de desempenho)
%recebido pelo trem quando parado na estacao:
%seu valor pode ser de 63% ou 50% em relacao a nominal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%montagem de vetor com velocidade constante
%aceleracao e/ou desaceleracao zero
Rv=6*((A+(B*vt*3.6)+(C*vt*vt*3.6*3.6))*pcar); %forca resistente ao movimento em N (formula de Davis)
Framp=rampa(st);             %verifica se trem em rampa
Fcurva=curva(st);            %verifica se trem em curva
Fr=Rv+Framp+Fcurva;          %somatoria das forcas resistentes
acel(t)=0;                   %variavel final de aceleracao em m/s2
st=st+(vt*delta_t);          %atualizacao da posicao
vel(t)=vt;                   %variavel final de velocidade em m/s (velocidade constante)
pos(t)=st;                   %variavel final de posicao em m
Fmt(t)=Fr;                    %variavel final de forca matriz em N
Ptrem(t)=-((Fr*vt)/rend)-paux;  %variavel final de potencia eletrica
return
