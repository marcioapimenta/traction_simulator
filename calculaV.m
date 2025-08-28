%funcao para calcular a tensao e corrente em cada no
function [vatual]=calculaV(G,I,idi,vias)

global Gcross tint nativos ntrem nret narm;
global vterra vground1 vground2 Verro;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%na primeira iteracao do primeiro intante, o valor das tensoes sobre todos
%os ativos (vatual) e a nominal, carregado na rotina eletrica.m
%nesse mesmo instante, todos os trens tracionando ou freando sem restricao
%e todas retificadoras ligadas, carregado na rotina eletrica.m
%em cada instante, necessario processo iterativo para convergencia
%da potencia dos trens
%tensao inicial do processo iterativo do proximo instante igual a final do
%instante anterior
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo das tensoes sobre todos os nos do circuito
V=G\I';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% rotina para atualizar valor de tensão dos ativos %%%%%%%%%%%
for i=1:nativos
    if idi(i)<=ntrem     %trem
        if vias(idi(i))==1  %se trem esta na via 1
            vatual(idi(i))=V(4*i-3)-V(4*i-2);
        else %se trem esta na via 2
            vatual(idi(i))=V(4*i)-V(4*i-1);
        endif
    elseif idi(i)>ntrem && idi(i)<=nret %retificadora
        vatual(idi(i))=V(4*i-3)-V(4*i-2);
        vterra(idi(i)-ntrem)=V(4*i-2);
    %elseif idi(i)>nret && idi(i)<=narm   %armazenador
    else %cabo crossbound
        vatual(idi(i))=V(4*i-2)-V(4*i-1);
    endif
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction
