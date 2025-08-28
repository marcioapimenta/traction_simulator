%funcao para montar o vetor de corrente do sistema
function [iatual,I,CR]=montaI(Pote,idi,vias,vatual,iatual)

global esttrem Efreio a Un Umin2 Umax1 Umaxfe Umax2 Umax3 Ud0 Pret ntrem nret narm nativos paux;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% montagem do vetor de correntes dos nos para cada tipo de ativo %%%%%
%quando corrente sai do no, sinal negativo
%quando corrente entra do no, sinal positivo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iantes=iatual;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%montagem do vetor de correntes
for i=1:nativos
    if idi(i)<=ntrem      %trem
        if vatual(idi(i))<=0.9*Umin2 || vatual(idi(i))>=Umax3 %se tensao muito baixa ou muito alta, trem e desligado
            esttrem(idi(i))=0;
            cr(idi(i))=0;
            Ia=0;
        elseif vatual(idi(i))>=0.9*Umin2 && vatual(idi(i))<Umin2 %se tensao baixa, trem com tracao desligada
            esttrem(idi(i))=5;
            cr(idi(i))=0;
            Ia=paux/vatual(idi(i));
        elseif vatual(idi(i))>=Umin2 && vatual(idi(i))<(a*Un) && Pote(idi(i))<=0 %reducao de tracao, tenta subir tensao
            esttrem(idi(i))=2;
            if (a*Un)-vatual(idi(i))>Efreio
                cr(idi(i))=1;
                Ia=(1-((abs((a*Un)-(vatual(idi(i)))))/(a*Un)))*iantes(idi(i));
            else
                cr(idi(i))=0;
                Ia=iantes(idi(i));
            endif
        elseif vatual(idi(i))>=Umax1 && vatual(idi(i))<Umaxfe %se tensao alta, ha atuacao do resistor, tenta baixar tensao
            esttrem(idi(i))=3;
            if vatual(idi(i))-Umax1>Efreio
                cr(idi(i))=1;
                if Pote(idi(i))>0 %se trem freando, corrente diminui
                    Ia=(1-((abs(vatual(idi(i))-Umax1))/Umax1))*iantes(idi(i));
                else              %se trem tracionando, corrente aumenta
                    Ia=(1+((abs(vatual(idi(i))-Umax1))/Umax1))*iantes(idi(i));
                endif
            else
                cr(idi(i))=0;
                Ia=iantes(idi(i));
            endif
        elseif vatual(idi(i))>=Umaxfe && vatual(idi(i))<Umax3 %se tensao alta, blend de freio ou desligada tracao
            esttrem(idi(i))=4;
            if Pote(idi(i))>0 %se trem em freio
                if vatual(idi(i))-(Umaxfe)>Efreio
                    cr(idi(i))=1;
                    Ia=(1-((abs(vatual(idi(i))-Umaxfe))/Umaxfe))*iantes(idi(i));
                else
                    cr(idi(i))=0;
                    Ia=iantes(idi(i));
                endif
            else              %se trem em tracao, desliga pois nao consegue consumir mais corrente
                cr(idi(i))=0;
                Ia=0;
            endif
        else %tensao em regiao de operacao normal
            esttrem(idi(i))=1;
            cr(idi(i))=0;
            Ia=Pote(idi(i))/vatual(idi(i));
        endif
        %dependendo da via que o trem esta, corrente vai ao no 1 ou 4 do ativo
        if vias(idi(i))==1
            I(4*i-3)=Ia;
            I(4*i-2)=-Ia;
            I(4*i-1)=0;
            I(4*i)=0;
            iatual(idi(i))=Ia;
        else
            I(4*i-3)=0;
            I(4*i-2)=0;
            I(4*i-1)=-Ia;
            I(4*i)=Ia;
            iatual(idi(i))=Ia;
        endif
    elseif idi(i)>ntrem && idi(i)<=nret %retificadora
        I(4*i-3)=Ud0(idi(i)-ntrem)/(((Ud0(idi(i)-ntrem)*Un)-(Un*Un))/Pret(idi(i)-ntrem));
        I(4*i-2)=-I(4*i-3);
        I(4*i-1)=0;
        I(4*i)=0;
        iatual(idi(i))=I(4*i-3);
    %elseif idi(i)>nret && idi(i)<=narm   %armazenador
    else %cabo crossbound
        I(4*i-3)=0;
        I(4*i-2)=0;
        I(4*i-1)=0;
        I(4*i)=0;
        iatual(idi(i))=I(4*i-2);
    endif
endfor
if sum(cr)==0
    CR=0;
else
    CR=1;
endif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction
