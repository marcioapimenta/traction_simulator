%funcao para calcular a potencia com o resultado obtido atraves da AN (V e I)
function [Patual]=calculaP(vatual,iatual)

global ntrem;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo da potencia a partir dos valores de vatual e iatual
for i=1:ntrem
    Patual(i)=vatual(i)*iatual(i);
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction
