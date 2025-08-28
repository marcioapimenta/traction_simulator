function [Fcurva]=curva(st)

global tam_trem mt coord_curva forca_curva;

%rotina para verificar se trem esta em regiao de curva
%caso trem em regiao de curva, calculo da forca resistiva ao movimento
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%o vetor coord_curva criado em parametros.m e composto da seguinte forma:
%o elemento 2*i-1 equivale ao marco de comeco da curva i, em m
%o elemento 2*i equivale ao marco do final da curva i, em m
%o vetor forca_curva corresponde a forca especifica de cada curva, em N/kN

Fcurva=0; %inicializa variavel de forca restritiva
%verifica em qual ponto do percurso em relacao aos marcos de curva o comeco do trem e o fim do trem esta
if st>coord_curva(end)
  cabeca=length(coord_curva);
else
  cabeca=find(coord_curva>=st)(1)-1;
end
if (st-tam_trem)>coord_curva(end)
  cauda=length(coord_curva);
else
  cauda=find(coord_curva>=(st-tam_trem))(1)-1;
end
##%%%%%%%%%%%%%%%%%%%%%%% calculo da forca resistiva %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if cabeca==cauda           %trem inteiramente entre dois marcos topograficos
    if cabeca==0 || cabeca>length(forca_curva)%trem nao chegou na primeira curva ou inteiramente fora da ultima curva
        Fcurva=0;
    else
        Fcurva=forca_curva(cabeca)/1000*mt*9.80665; %forca restritiva integral, pois todo o trem esta na mesma curva
    end
else                       %trem em mais de uma regiao de curva
    for i=cauda:cabeca
        if i==cauda
            if cauda==0 %cauda nao chegou na primeira curva
                Fcurva=0;
            else
                Fcurva=forca_curva(i)/1000*mt*9.80665*((coord_curva(i+1)-(st-tam_trem))/tam_trem);
            end
        elseif i==cabeca
            Fcurva=Fcurva+(forca_curva(i)/1000*mt*9.80665*((st-coord_curva(i))/tam_trem));
        else
            Fcurva=Fcurva+(forca_curva(i)/1000*mt*9.80665*((coord_curva(i+1)-coord_curva(i))/tam_trem));
        end
    end
end
return
