function [Framp]=rampa(st)

global tam_trem mt coord_ramp inclina_ramp ext_linha;

%forca resistiva quando trem em subida (sinal positivo)
%forca propulsora quando trem em descida (sinal negativo)
%a rotina funciona baseada em dois vetores:
%o vetor coord_ramp criado em imp_dados.m e composto pelos marcos topograficos
%de eventos de rampa de toda a linha (comeco ou fim de rampa)
%o vetor inclina_ramp corresponde a inclinacao entre cada marco de coord_ramp
%em positiva, negativa ou zero.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Framp=0; %inicializa variavel de forca restritiva
%verifica entre quais marcos a cabeca e a cauda do trem estao
if st>coord_ramp(end)
  cabeca=length(coord_ramp);
else
  cabeca=find(coord_ramp>=st)(1)-1;
end
if (st-tam_trem)>coord_ramp(end)
  cauda=length(coord_ramp);
else
  cauda=find(coord_ramp>=(st-tam_trem))(1)-1;
end
##%%%%%%%%%%%%%%%%%%%%%%% calculo da forca resistiva %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if cabeca==cauda           %trem inteiramente entre dois marcos topograficos
    if cabeca==0 || cabeca>length(inclina_ramp)%trem nao chegou na primeira rampa ou inteiramente fora da ultima rampa
        Framp=0;
    else
        Framp=inclina_ramp(cabeca)/100*mt*9.80665; %forca restritiva integral, pois todo o trem esta na mesma rampa
    end
else                       %trem em mais de uma regiao de inclinacao
    for i=cauda:cabeca
        if i==cauda
            if cauda==0 %cauda nao chegou na primeira rampa
                Framp=0;
            else
                Framp=inclina_ramp(i)/100*mt*9.80665*((coord_ramp(i+1)-(st-tam_trem))/tam_trem);
            end
        elseif i==cabeca
            Framp=Framp+(inclina_ramp(i)/100*mt*9.80665*((st-coord_ramp(i))/tam_trem));
        else
            Framp=Framp+(inclina_ramp(i)/100*mt*9.80665*((coord_ramp(i+1)-coord_ramp(i))/tam_trem));
        end
    end
end
return
