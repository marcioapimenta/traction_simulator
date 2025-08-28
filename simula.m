clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Arquivos para rodar a simulacao como um todo %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fflush(stdout);
linha=0;
while linha~='A' && linha~='B'
  linha=input('Qual linha deseja simular (A ou B)? ','s');
  if linha~='A' && linha~='B'
    disp('');
    disp('Opção invalida, entre novamente com a linha desejada');
    disp('');
  end
end
imp_dados;
marcha;
trafego;
eletrica;
