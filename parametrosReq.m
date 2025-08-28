%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Arquivo para alteracoes no sistema para calculo de Req %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parametros usados na rotina montaG.m para alteracao de impedancia na regiao da
%trinca

global metodoreq qtrinc loctrinc viatrinc ttrinc Gretpos Gretneg Gcross;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% escolha de metodo para calculo da resistencia equivalente %%%%%%%%%%
%consideratrens (dados oriundos da simulacao eletrica)
%0-nao considera a impedancia dos outros trens no sistema para calcular a Req
%1-considera a impedancia dos outros trens vindas da simulacao eletrica
consideratrens=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% insercao de parametros %%%%%%%%%%%%%%%%%%%%%%%%%%%%
qtrinc=0;         %quantidade de trincas no sistema
qretfalha=0;      %quantidade de retificadoras com cabos rompidos
qcrossfalha=0;    %quantidade de crossbound com cabos rompidos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% insercao de trilho trincado %%%%%%%%%%%%%%%%%%%%%%%%%%
%localizacao de via da trinca (trio de variaveis de acordo com quant. de trincas
loctrinc(1)=6000; %localizacao, em metros, da trinca
viatrinc(1)=1;    %via da trinca, 1 ou 2
ttrinc(1)=1;      %quantidade de trilhos trincados, 1 ou 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% insercao de cabo rompido retificadora %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% nomeacao das retificadoras em falha - preencher %%%%%%%%%%%%%%%%
retfalha(1)=12;  %WPDS
qcabospos(1)=0; %quantidade de cabos positivos rompidos (0-5)
qcabosneg(1)=2; %quantidade de cabos negativos rompidos (0-6)

%retfalha(2)=5;  %WVTD
%qcabospos(2)=1; %quantidade de cabos positivos rompidos (0-5)
%qcabosneg(2)=1; %quantidade de cabos negativos rompidos (0-6)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% insercao de cabo rompido do crossbound %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% nomeacao dos crossbound em falha - preencher %%%%%%%%%%%%%%%%%
crossfalha(1)=10;%na Linha 3-Vermelha existem 50 crossbounds
qcabos(1)=1;     %quantidade de cabos rompidos (0-2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% CALCULOS E VERIFICACOES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%altera condutancia positiva e negativa da(s) retificadora(s) em falha
if qretfalha~=0
    for i=1:qretfalha
        if qcabospos(i)==0
            Gretpos(retfalha(i))=1/(100*0.00000966);   %100m cabo pos. retificadora (5x750MCM - 48,3mohm/km)
        elseif qcabospos(i)==1
            Gretpos(retfalha(i))=1/(100*0.000012075);   %100m cabo pos. retificadora (4x750MCM - 48,3mohm/km)
        elseif qcabospos(i)==2
            Gretpos(retfalha(i))=1/(100*0.0000161);   %100m cabo pos. retificadora (3x750MCM - 48,3mohm/km)
        elseif qcabospos(i)==3
            Gretpos(retfalha(i))=1/(100*0.00002415);   %100m cabo pos. retificadora (2x750MCM - 48,3mohm/km)
        elseif qcabospos(i)==4
            Gretpos(retfalha(i))=1/(100*0.0000483);   %100m cabo pos. retificadora (1x750MCM - 48,3mohm/km)
        elseif qcabospos(i)==5
            Gretpos(retfalha(i))=1/(100*0.000483);   %100m cabo pos. retificadora (0x750MCM - 48,3mohm/km)
        end
        if qcabosneg(i)==0
            Gretneg(retfalha(i))=1/(110*0.00000805);   %110m cabo neg. retificadora (6x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==1
            Gretneg(retfalha(i))=1/(110*0.00000966);   %110m cabo neg. retificadora (5x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==2
            Gretneg(retfalha(i))=1/(100*0.000012075);  %110m cabo neg. retificadora (4x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==3
            Gretneg(retfalha(i))=1/(110*0.0000161);    %110m cabo neg. retificadora (3x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==4
            Gretneg(retfalha(i))=1/(110*0.00002415);   %110m cabo neg. retificadora (2x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==5
            Gretneg(retfalha(i))=1/(110*0.0000483);    %110m cabo neg. retificadora (1x750MCM - 48,3mohm/km)
        elseif qcabosneg(i)==6
            Gretneg(retfalha(i))=1/(110*0.000483);     %110m cabo neg. retificadora (0x750MCM - 48,3mohm/km)
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%altera condutancia do crossbound em falha
if qcrossfalha~=0
    for i=1:qcrossfalha
        if qcabos(i)==0
            Gcross(crossfalha(i))=1/(30*0.00004005); %30m cabo (2x240mm2 - 80,1mohm/km)
        elseif qcabos(i)==1
            Gcross(crossfalha(i))=1/(30*0.0000801);  %30m cabo (1x240mm2 - 80,1mohm/km)
        elseif qcabos(i)==2
            Gcross(crossfalha(i))=1/(30*0.000801);   %30m cabo (0x240mm2 - 80,1mohm/km)
        end
    end
end

%%%%%%%%%%%%%%% Verificacao das quantidades dos parametros %%%%%%%%%%%%%%%%%%%%
if qtrinc~=0
    if qtrinc~=length(loctrinc) || qtrinc~=length(viatrinc) || qtrinc~=length(ttrinc)
        disp('ATENÇÃO: Incompatibilidde entre quantidade de trincas, favor verificar!');
    end
end

if qretfalha~=0
    if qretfalha~=length(retfalha) ||qretfalha~=length(qcabospos) || qretfalha~=length(qcabosneg)
        disp('ATENÇÃO: Incompatibilidde entre retificadoras em falha, favor verificar!');
    end
end

if qcrossfalha~=0
    if qcrossfalha~=length(crossfalha) || qcrossfalha~=length(qcabos)
        disp('ATENÇÃO: Incompatibilidde entre crossbounds em falha, favor verificar!');
    end
end
