function []=parado(st,vt,temp)

global t paux vel pos Fmt Ptrem;
%funcao que completara vetores de posicao e potencia enquanto trem parado
%na plataforma
t0=t;    %variavel para registro do tempo inicial de plataforma
while t<t0+temp
  vel(t)=vt;
  pos(t)=st;
  Fmt(t)=0;
  Ptrem(t)=-paux;
  t=t+1;
end
t=t-1; %ajuste do tempo final para entrada nas proximas rotinas
return
