%funcao responsavel pelo processo iterativo
function [vatual,iatual,nconv]=iteracao(Scre,Pote,idi,vias,vatual,vantes,iatual)

global ntotal ntrem nativos Verro nmaximo tint Veterro k nativos eatual;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%montagem da matriz de condutancia apenas uma vez durante processo iterativa
G=montaG(Scre,idi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%comeco do processo iterativo
nconv=0;       %variavel que indica nao convergencia
nint=0;        %numero de iteracoes
while nint<=nmaximo
    [iatual,I,CR]=montaI(Pote,idi,vias,vatual,iatual);
    vantes=vatual;
    vatual=calculaV(G,I,idi,vias);
    %novo calculo de erro de potencia dos trens para checar convergencia
    for i=1:ntrem
        eatual(i)=abs(vatual(i)-vantes(i));
    endfor
    ntotal=ntotal+1;
    nint=nint+1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %se todos elementos do vetor de erro for menor que pre-estabelicido, sai do loop
    if (eatual<=Verro && CR==0) || (eatual<=Verro && nint>=0.9*nmaximo)
        break
    endif
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nint==nmaximo %caso nao haja convergencia
        Veterro(k,1)=tint;
        Veterro(k,2:ntrem+1)=eatual;
        k=k+1;
        nconv=1;
    endif
endwhile
endfunction
