%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Arquivo para entrada de parametros para simulacao %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global delta_t tam_plat num_est acc dcc mv mc txr paux rfr pmt vmn ne lt at rend;
global ext_linha num_trem num_ret tam_trem loc_est loc_ret num_ramp inclina_ramp;
global num_curva temp_term coord_ramp coord_curva forca_curva cross temp_plat;
global Un Ud0 imp_pos imp_neg Umin2 Umax1 Umax2 Umaxfe Umax3 a Pret Verro Efreio;
global Gterra Glig Sret Gcross Gcret Gretpos Gretneg Rret num_arm num_cross redc diam;
global vpct vpcf tt tf Gearth nmaximo;
pkg load io;           %carrega pacote para ler arquivo excel com parametros
if linha=='A'
  arquivo='parametrosLA.xlsx';
elseif linha=='B'
  arquivo='parametrosLB.xlsx';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% PARAMETROS RELACIONADOS A MARCHA  %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% Parametros gerais da linha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta_t=xlsread(arquivo,'geral','b1');   %intervalo de tempo amostral (s)
nmaximo=xlsread(arquivo,'geral','b2');   %numero maximo de iteracoes no processo de convergencia
tam_plat=xlsread(arquivo,'tam_plat');    %tamanho da plataforma em metros
num_est=xlsread(arquivo,'geral','b3');   %numero de estacoes (parada adicional em TUC - TM3)
num_ramp=xlsread(arquivo,'geral','b4');  %numero de rampas na via
num_curva=xlsread(arquivo,'geral','b5'); %numero de curvas na via
num_trem=xlsread(arquivo,'geral','b6');  %numero de trens operando na via
num_ret=xlsread(arquivo,'geral','b7');   %numero de subestacoes retificadoras
num_arm=xlsread(arquivo,'geral','b8');   %numero de armazenadores
num_cross=xlsread(arquivo,'geral','b9'); %numero de cabos crossbound
ext_linha=xlsread(arquivo,'geral','b10');%extensao da linha, local da ultima parada


%%%%%%%%%%%%%%%%%%%% Parametros dos trens da linha %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dados Frota L
tam_trem=xlsread(arquivo,'trem','b1');%tamanho do trem em m
acc=xlsread(arquivo,'trem','b2');     %aceleracao nominal em m/s2
dcc=xlsread(arquivo,'trem','b3');     %desaceleracao nominal em m/s2
mv=xlsread(arquivo,'trem','b4');      %massa do trem vazio em kg
mc=xlsread(arquivo,'trem','b5');      %massa do carregamento do trem em kg
txr=xlsread(arquivo,'trem','b6');     %coeficiente "taxa de massa rotativa" (%)
paux=xlsread(arquivo,'trem','b7');    %potencia eletrica dos auxiliares em W
rfr=xlsread(arquivo,'trem','b8');     %valor da resistencia de freio do trem em ohm
vpct=xlsread(arquivo,'trem','b9');    %velocidade forca constante tracao em rpm
tt=xlsread(arquivo,'trem','b10');     %torque inicial de tração em Nm
vpcf=xlsread(arquivo,'trem','b11');   %velocidade forca constante freio em rpm
tf=xlsread(arquivo,'trem','b12');     %torque inicial em frenagem em Nm
redc=xlsread(arquivo,'trem','b13');   %fator de reducao da caixa redutora do trem
diam=xlsread(arquivo,'trem','b14');   %diametro medio de roda do trem em mm
ne=xlsread(arquivo,'trem','b15');     %numero de eixos motorados
lt=xlsread(arquivo,'trem','b16');     %largura da seccao transversal do carro em metros
at=xlsread(arquivo,'trem','b17');     %altura da seccao transversal do carro em metros
rend=xlsread(arquivo,'trem','b18');   %rendimento do trem (%)

%%%%%%%%%%%% Taxa de carregamento do trem saindo das estações %%%%%%%%%%%%%%%%%
%valor de 0 a 1, aplicando taxa de carregamento do trem ao sair de cada estacao
%como caracteristica de carregamento depende da via que o trem percorre
%valor e carregado para a Via 1 (ida) e Via 2 (volta)
txc=xlsread(arquivo,'txc','c2:c1000');
%verificacao da taxa de carregamento
if length(txc)~=(2*num_est)-2
  disp('ATENÇÃO: Imcompatibilidde na taxa de carregamento, favor verificar');
end

%%%%%%%%%%%%%%%%% Localizacao das estacoes na linha %%%%%%%%%%%%%%%%%%%%%%%%%%%
%marco topografico do centro da plataforma em relacao ao comeco da via
%no caso da linha 1, o comeca da via foi considerado a plataforma de JAB
%a ultima estacao da via foi considerada a TM3 em TUC
%dessa forma, sua localizacao coincide com a extensao da via
loc_est=xlsread(arquivo,'loc_est');

%%%%%%%%%%%%%%% Localizacao das retificadoras na linha %%%%%%%%%%%%%%%%%%%%%%%%
%marco topografico da localizacao das estacoes retificadoras
loc_ret=xlsread(arquivo,'loc_ret');

%%%%%%%%%%%%%%%%%% Localizacao das rampas na linha %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INSERIR DADOS SOMENTE RELATIVOS A IDA %%%%%%%%%%%%%%%%%%%%%%%%
%cada rampa tem 3 parametros: marco inicial, marco final e inclinacao
%marcos em m e inclinacao em %
%inclinicao positiva - subida
%inclinacao negativa - descida
ramp=xlsread(arquivo,'ramp');

%%%%%%%%%%%%%%%%%% Localizacao das curvas na linha %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INSERIR DADOS SOMENTE RELATIVOS A IDA %%%%%%%%%%%%%%%%%%%%%%%%
%cada curva tem 3 parametros: marco inicial, marco final e raio, em m
curv=xlsread(arquivo,'curv','a1:d1000');
f_curva=xlsread(arquivo,'curv','e1:e1000');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% PARAMETROS RELACIONADOS A ELETRICA %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% dados globais do sistema %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Un=xlsread(arquivo,'eletrica','b1');     %tensao nominal, em volts
imp_pos=xlsread(arquivo,'eletrica','b2');%impedancias do terceiro trilho (positivo), em ohm/m
imp_neg=xlsread(arquivo,'eletrica','b3');%impedancia do negativo (2 x TR57 - 35mohm/km), em ohm/m
Umin2=xlsread(arquivo,'eletrica','b4');  %limite inferior de tensao para tracao plena
a=xlsread(arquivo,'eletrica','b5');      %fator para limite superior de tensao para tracao plena
Umax1=xlsread(arquivo,'eletrica','b6');  %limite superior de tensao para tracao com freio reostatico
Umax2=xlsread(arquivo,'eletrica','b7');  %limite superior nominal de tensao para operacao do sistema
Umaxfe=xlsread(arquivo,'eletrica','b8'); %limite superior para freio reostatico
Umax3=xlsread(arquivo,'eletrica','b9');  %limite superior de pico para operacao do sistema
Glig=xlsread(arquivo,'eletrica','b10');  %condutancia modelando conexao entre dois pontos (100 x menor)
Gearth=xlsread(arquivo,'eletrica','b11');%condutancia entre terras (via e referencia), em S/m (EN50122-2)
Verro=xlsread(arquivo,'eletrica','b12'); %erro de tensoa admissivel para convergencia
Efreio=xlsread(arquivo,'eletrica','b13');%erro de tensao admissivel quando em atuacao de resistor do trem

%%%%%%%%%%%%%%%%%%%%%%% dados das retificadoras %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nr=xlsread(arquivo,'dados_rets','b10');        %numero de retificadoras para verificacao
Pret=xlsread(arquivo,'dados_rets','b2:dg2');   %potencia nominal em watts
Ud0=xlsread(arquivo,'dados_rets','b3:dg3');    %tensao em vazio da retificadora
Gterra=xlsread(arquivo,'dados_rets','b4:dg4'); %condutancia a terra da retificadora
Gcret=xlsread(arquivo,'dados_rets','b5:dg5');  %crossbound no retorno 30m cabo (2x240mm2 - 80,1mohm/km)
Gretpos=xlsread(arquivo,'dados_rets','b6:dg6');%200m cabo pos. retificadora (5M-4 cada via de 1250MCM - 29,8mohm/km;4,25M-5 cada via de 400mm2 - 48,6mohm/km)
Gretneg=xlsread(arquivo,'dados_rets','b7:dg7');%220m cabo neg. retificadora (5M-5 cada via de 1250MCM - 29,8mohm/km;4,25M-5 cada via de 400mm2 - 48,6mohm/km)
Sret=xlsread(arquivo,'dados_rets','b8:dg8');   %posicao da retificadora

%%%%%%%%%%%%%%%%%%%%%%% dados dos armazenadores %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% na=0;                             %variavel do numero de armazenadores
% %armazenador n
% na=na+1;                          %atualizacao do numero de armazenadores
% Parm(num_arm)=0;                  %potencia nominal em watts
% Sarm(num_arm)=0;                  %posicao do armazenador
% m_via(num_arm)=0;                 %via onde armazenador esta instalado

%%%%%%%%%%%%%%%%%%%%%%%% dados dos Crossbounds %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%marco topografico de localizacao dos cabos de crossbound
cross=xlsread(arquivo,'cross');

%condutancia equivalente e 30m cabo crossbound (2x240mm2 - 80,1mohm/km)
Gcross=xlsread(arquivo,'cross','c2:c1000');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% CALCULOS E VERIFICACOES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%os dados das rampas sao inseridos somente para a ida
%todavia na volta do trem, a inclinacao sera a oposta, com alteracao dos dados
%topograficos
for i=num_ramp+1:2*num_ramp
  ramp(i,1)=(2*ext_linha)-ramp(i-(2*i-2*num_ramp-1),2);
  ramp(i,2)=(2*ext_linha)-ramp(i-(2*i-2*num_ramp-1),1);
  ramp(i,3)=-ramp(i-(2*i-2*num_ramp-1),3);
end
%montagem de vetor com marcos de comeco e fim de todas as rampas da via
%dada cada rampa, i, elemento 2*i-1 comeco da rampa e 2*i final
%posteriormente montado vetor com marcos topograficos de toda a linha com eventos
%de comeco ou termino de rampa (elementos repetidos do vetor anterior retirados)
%montagem do vetor de inclinacao de toda a via, com inclinacao das rampas para
%trechos dentro da rampa e nulo para trechos fora das rampas
j=1;
for i=1:2*num_ramp
  coord_ramp(2*i-1)=ramp(i,1);
  coord_ramp(2*i)=ramp(i,2);
  if i==1
    inclina_ramp(j)=ramp(i,3);
  elseif coord_ramp(2*i-1)~=coord_ramp(2*(i-1))
    inclina_ramp(j)=0;
    j=j+1;
    inclina_ramp(j)=ramp(i,3);
  else
    inclina_ramp(j)=ramp(i,3);
  end
  if i<2*num_ramp
    if coord_ramp(i)>coord_ramp(i+1) || ramp(i,2)>ramp(i+1,1)
      disp('ATENÇÂO: Incompatibilidde entre marcos topograficos da rampa:');
      disp(i);
    end
  end
  j=j+1;
end
inclina_ramp(j)=0; %inclinacao da via apos ultima rampa, caso haja
coord_ramp=unique(coord_ramp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%os dados das curvas sao inseridos somente para a ida
%todavia na volta do trem, o marco topografico sera alterado
for i=num_curva+1:2*num_curva
  curv(i,1)=(2*ext_linha)-curv(i-(2*i-2*num_curva-1),2);
  curv(i,2)=(2*ext_linha)-curv(i-(2*i-2*num_curva-1),1);
  f_curva(i)=f_curva(i-(2*i-2*num_curva-1));
end
%montagem de vetor com marcos de comeco e fim de todas as curvas da via
%dada cada curva, i, elemento 2*i-1 comeco da curva e 2*i final
%posteriormente montado vetor com marcos topograficos de toda a linha com eventos
%de comeco ou termino de curva (elementos repetidos do vetor anterior retirados)
%montagem do vetor de forca da curvas de toda a via, com valores para
%trechos dentro da curva e nulo para trechos fora das curvas
%montagem do vetor de forca da curva i, em N/kN, dependendo do seu raio
j=1;
for i=1:2*num_curva
  coord_curva(2*i-1)=curv(i,1);
  coord_curva(2*i)=curv(i,2);
  if i==1
    forca_curva(j)=f_curva(i);
  elseif coord_curva(2*i-1)~=coord_curva(2*(i-1))
    forca_curva(j)=0;
    j=j+1;
    forca_curva(j)=f_curva(i);
  else
    forca_curva(j)=f_curva(i);
  end
  if i<2*num_curva
    if coord_curva(i)>coord_curva(i+1) || curv(i,2)>curv(i+1,1)
      disp('ATENÇÂO: Incompatibilidde entre marcos topograficos da curva:');
      disp(i);
    end
  end
  j=j+1;
end
forca_curva(j)=0; %forca de curva da via apos ultima curva, caso haja
coord_curva=unique(coord_curva);
%%%%%%%%%%%%%%% Verificacao das quantidades de parametros %%%%%%%%%%%%%%%%%%%%%
if length(loc_est)~=(2*num_est)-1
  disp('ATENÇÃO: Incompatibilidde entre dados das estações, favor verificar!');
end

if length(loc_ret)~=num_ret
  disp('ATENÇÃO: Incompatibilidde entre localizacao das retificadoras, favor verificar!');
end

if length(cross)~=num_cross
  disp('ATENÇÃO: Incompatibilidde entre localizacao dos crossbounds, favor verificar!');
end
if nr~=num_ret
  disp('ATENÇÃO: Incompatibilidde entre dados eletricos das retificadoras, favor verificar!');
end

if size(ramp)(1)~=2*num_ramp
  disp('ATENÇÃO: Incompatibilidde entre dados das rampas, favor verificar!');
end

if size(curv)(1)~=2*num_curva
  disp('ATENÇÃO: Incompatibilidde entre dados das curvas, favor verificar!');
end
