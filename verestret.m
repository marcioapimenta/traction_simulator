%funcao para alterar estado das retificadoras conforme seu nivel de tensao
function [estat,iativo,trocaest]=verestret(idi,estret,vatual,iatual)

global nativos ntrem nret narm;
global a Un Ud0 Umin2 Umax1 Umax2 Umaxfe Umax3 Rret Roff Pret;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rotina sinaliza se estados dos ativos foi alterado em sua execucao, pois
%enquanto houver alteracao, calculaV devera ser executada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
est_antes=estret;
%verifica estado das retificadoras e retificadora
for i=1:nativos
    if i>ntrem && i<=nret %retificadora
        if vatual(i)<=Ud0(i-ntrem) %tensao menor que a em vazio
            estat(i-ntrem)=1;           %retificadora ligada
            Rret(i-ntrem)=((Ud0(i-ntrem)*Un)-(Un*Un))/Pret(i-ntrem);
        elseif vatual(i)>Ud0(i-ntrem) %tensao maior que a em vazio
            estat(i-ntrem)=0;           %retificadora desligada
            Rret(i-ntrem)=(vatual(i)*(((Ud0(i-ntrem)*Un)-(Un*Un))/Pret(i-ntrem)))/Ud0(i-ntrem);
        endif
        iativo(i)=iatual(i)-(vatual(i)/Rret(i-ntrem));
    else
        iativo(i)=iatual(i);
    endif
endfor
%verifica se houve alteracao de estado apenas de retificadora
if estat==est_antes
    trocaest=0;
else
    trocaest=1;
endif
endfunction
