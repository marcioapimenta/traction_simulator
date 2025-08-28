%funcao para montar a matriz de condutancias do sistema
function [G]=montaG(Scre,idi)

global imp_pos imp_neg ntrem nret narm nativos Gcross Gcret;
global Gearth Gretpos Gretneg Gterra Rret Gpos1;

%a montagem do circuito equivalente sera em 4 linhas, sendo:
%1 - impendancia da via 1
%2 - impedancia do trilho de retorno da via 1
%3 - impedancia do trilho de retorno da via 2
%4 - impedancia da via 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%matriz de condutancia praa analise nodal por inspecao, sendo simetrica
%cada elemento da diagonal principal positivo e equivale a soma de todas
%as condutancias ligadas ao no
%cada elemento Gij=Gji, negativo, correspondente a condutancia
%entre os nos i e j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% montagem do vetor de condutancia entre os ativos a cada instante %%%%
%vetor com dimensao nativos-1 por ser a condutancia entre os ativos
for i=1:(nativos-1)
    %caso dois ativos estejam no mesmo local, deve haver um espacamento
    %minimo para que nao haja divisao por zero
    if (Scre(i+1)-Scre(i))<=0
        dist=0.01;
    else
        dist=Scre(i+1)-Scre(i);
    endif
    %atribuicao de impedancias dos condutores positivos e negativos
    %das vias 1 e 2
    Gpos1(i)=1/(imp_pos*dist);
    Gpos2(i)=1/(imp_pos*dist);
    Gneg1(i)=1/(imp_neg*dist);
    Gneg2(i)=1/(imp_neg*dist);
    Gground(i)=Gearth*dist;
endfor
%atribuicao da condutancia a terra nas retificadoras e crossbounds
%condutancias a terra nao estao nos trens, portanto eles devem ser ignorados
for i=2:(nativos-1)
    if idi(i)<=ntrem
        Gground(i)=Gground(i)+Gground(i-1);
    endif
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% montagem da matriz de condutancia acordo com o tipo de ativo %%%%%%
%matriz G tem dimensao n x n, tendo em vista que o sistema tem duas vias
%positivos e retornos dessa forma a matriz n x n onde n = 4* nativos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reseta a matriz de condutancia e carrega com zeros
G=zeros(4*nativos);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%montagem da matriz de condutancia (diagonal principal e acima dela)
%ou seja: G(i,j) onde j>=i
%OBS.: caso haja alteracao no estado de retificadora, necessario nova montagem de G
for i=1:nativos
    if i==1 %se ativo primeiro do sistema
        if idi(i)<=ntrem %se ativo for trem
            G(4*i-2,4*i-2)=Gneg1(i);
            G(4*i-1,4*i-1)=Gneg2(i);
            if idi(i+1)>ntrem && idi(i+1)<=nret %se proximo ativo for retificadora
                G(4*i-3,4*i-3)=(Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem));
                G(4*i,4*i)=(Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem));
                G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                G(4*i-2,4*i+3)=-Gneg1(i);
                G(4*i-1,4*i+4)=-Gneg2(i);
                G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
            else %se proximo ativo nao for retificadora
                G(4*i-3,4*i-3)=Gpos1(i);
                G(4*i,4*i)=Gpos2(i);
                G(4*i-3,4*i+1)=-Gpos1(i);
                G(4*i-2,4*i+2)=-Gneg1(i);
                G(4*i-1,4*i+3)=-Gneg2(i);
                G(4*i,4*i+4)=-Gpos2(i);
            endif
        elseif idi(i)>ntrem && idi(i)<=nret %se ativo for retificadora
            G(4*i-2,4*i-2)=(2*Gretneg(idi(i)-ntrem))+(1/(Rret(idi(i)-ntrem)))+Gterra(idi(i)-ntrem);
            G(4*i-1,4*i-1)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg1(i)+Gground(i)/2;
            G(4*i,4*i)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg2(i)+Gground(i)/2;
            G(4*i-3,4*i-2)=-(1/(Rret(idi(i)-ntrem)));
            G(4*i-2,4*i-1)=-Gretneg(idi(i)-ntrem);
            G(4*i-2,4*i)=-Gretneg(idi(i)-ntrem);
            G(4*i-1,4*i)=-Gcret(idi(i)-ntrem);
            if idi(i+1)>ntrem && idi(i+1)<=nret %se proximo ativo for retificadora
                G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem))))+(1/(Rret(idi(i)-ntrem)));
                G(4*i-3,4*i+1)=-(((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem)))));
                G(4*i-1,4*i+3)=-Gneg1(i);
                G(4*i,4*i+4)=-Gneg2(i);
            else %se proximo ativo nao for retificadora
                G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i)-ntrem))/(Gpos1(i)+Gretpos(idi(i)-ntrem)))+((Gpos2(i)*Gretpos(idi(i)-ntrem))/(Gpos2(i)+Gretpos(idi(i)-ntrem)))+(1/(Rret(idi(i)-ntrem)));
                G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i)-ntrem))/(Gpos1(i)+Gretpos(idi(i)-ntrem)));
                G(4*i-1,4*i+2)=-Gneg1(i);
                G(4*i,4*i+3)=-Gneg2(i);
                G(4*i-3,4*i+4)=-((Gpos2(i)*Gretpos(idi(i)-ntrem))/(Gpos2(i)+Gretpos(idi(i)-ntrem)));
            endif
        %elseif idi(i)>nret && idi(i)<=narm %se ativo for armazenador
        else %se ativo for cabo crossbound
            G(4*i-2,4*i-2)=Gcross(idi(i)-narm)+Gneg1(i)+Gground(i)/2;
            G(4*i-1,4*i-1)=Gcross(idi(i)-narm)+Gneg2(i)+Gground(i)/2;
            G(4*i-2,4*i-1)=-Gcross(idi(i)-narm);
            if idi(i+1)>ntrem && idi(i+1)<=nret %se proximo ativo for retificadora
                G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                G(4*i,4*i)=((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
                G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                G(4*i-2,4*i+3)=-Gneg1(i);
                G(4*i-1,4*i+4)=-Gneg2(i);
                G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
            else %se proximo ativo nao for retificadora
                G(4*i-3,4*i-3)=Gpos1(i);
                G(4*i,4*i)=Gpos2(i);
                G(4*i-3,4*i+1)=-Gpos1(i);
                G(4*i-2,4*i+2)=-Gneg1(i);
                G(4*i-1,4*i+3)=-Gneg2(i);
                G(4*i,4*i+4)=-Gpos2(i);
            endif
        endif
    elseif i>1 && i<nativos %se ativo no meio do sistema
        if idi(i)<=ntrem %se ativo for trem
            G(4*i-2,4*i-2)=Gneg1(i)+Gneg1(i-1);
            G(4*i-1,4*i-1)=Gneg2(i)+Gneg2(i-1);
            if idi(i+1)>ntrem && idi(i+1)<=nret
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo e anterior ativo for retificadora
                    G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)))+((Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i,4*i)=((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)))+((Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                    G(4*i-2,4*i+3)=-Gneg1(i);
                    G(4*i-1,4*i+4)=-Gneg2(i);
                    G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
                else %se proximo ativo for retificadora e ativo anterior nao
                    G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)))+Gpos1(i-1);
                    G(4*i,4*i)=((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)))+Gpos2(i-1);
                    G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                    G(4*i-2,4*i+3)=-Gneg1(i);
                    G(4*i-1,4*i+4)=-Gneg2(i);
                    G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
                endif
            else
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo ativo nao for retificadora e ativo anterior retificadora
                    G(4*i-3,4*i-3)=Gpos1(i)+((Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i,4*i)=Gpos2(i)+((Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i-3,4*i+1)=-Gpos1(i);
                    G(4*i-2,4*i+2)=-Gneg1(i);
                    G(4*i-1,4*i+3)=-Gneg2(i);
                    G(4*i,4*i+4)=-Gpos2(i);
                else %se proximo ativo e anterior nao for retificadora
                    G(4*i-3,4*i-3)=Gpos1(i)+Gpos1(i-1);
                    G(4*i,4*i)=Gpos2(i)+Gpos2(i-1);
                    G(4*i-3,4*i+1)=-Gpos1(i);
                    G(4*i-2,4*i+2)=-Gneg1(i);
                    G(4*i-1,4*i+3)=-Gneg2(i);
                    G(4*i,4*i+4)=-Gpos2(i);
                endif
            endif
        elseif idi(i)>ntrem && idi(i)<=nret %se ativo for retificadora
            G(4*i-2,4*i-2)=(2*Gretneg(idi(i)-ntrem))+(1/(Rret(idi(i)-ntrem)))+Gterra(idi(i)-ntrem);
            G(4*i-1,4*i-1)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg1(i)+Gneg1(i-1)+((Gground(i)+Gground(i-1))/2);
            G(4*i,4*i)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg2(i)+Gneg2(i-1)+((Gground(i)+Gground(i-1))/2);
            G(4*i-3,4*i-2)=-(1/(Rret(idi(i)-ntrem)));
            G(4*i-2,4*i-1)=-Gretneg(idi(i)-ntrem);
            G(4*i-2,4*i)=-Gretneg(idi(i)-ntrem);
            G(4*i-1,4*i)=-Gcret(idi(i)-ntrem);
            if idi(i+1)>ntrem && idi(i+1)<=nret
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo e anterior ativo for retificadora
                    G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem))))+(1/(Rret(idi(i)-ntrem)));
                    G(4*i-3,4*i+1)=-(((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem)))));
                    G(4*i-1,4*i+3)=-Gneg1(i);
                    G(4*i,4*i+4)=-Gneg2(i);
                else %se proximo ativo for retificadora e ativo anterior nao
                    G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i-1))/(Gretpos(idi(i)-ntrem)+Gpos1(i-1)))+((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i-1))/(Gretpos(idi(i)-ntrem)+Gpos2(i-1)))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem))))+(1/(Rret(idi(i)-ntrem)));
                    G(4*i-3,4*i+1)=-(((Gretpos(idi(i)-ntrem)*Gpos1(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos1(i)*Gretpos(idi(i+1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i)*Gretpos(idi(i+1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i+1)-ntrem))+(Gpos2(i)*Gretpos(idi(i+1)-ntrem)))));
                    G(4*i-1,4*i+3)=-Gneg1(i);
                    G(4*i,4*i+4)=-Gneg2(i);
                endif
            else
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo ativo nao for retificadora e ativo anterior retificadora
                    G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos1(i))/(Gretpos(idi(i)-ntrem)+Gpos1(i)))+((Gretpos(idi(i)-ntrem)*Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i))/(Gretpos(idi(i)-ntrem)+Gpos2(i)))+(1/(Rret(idi(i)-ntrem)));
                    G(4*i-3,4*i+1)=-((Gretpos(idi(i)-ntrem)*Gpos1(i))/(Gretpos(idi(i)-ntrem)+Gpos1(i)));
                    G(4*i-1,4*i+2)=-Gneg1(i);
                    G(4*i,4*i+3)=-Gneg2(i);
                    G(4*i-3,4*i+4)=-((Gretpos(idi(i)-ntrem)*Gpos2(i))/(Gretpos(idi(i)-ntrem)+Gpos2(i)));
                else %se proximo ativo e anterior nao for retificadora
                    G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i-1))/(Gretpos(idi(i)-ntrem)+Gpos1(i-1)))+((Gretpos(idi(i)-ntrem)*Gpos1(i))/(Gretpos(idi(i)-ntrem)+Gpos1(i)))+((Gretpos(idi(i)-ntrem)*Gpos2(i-1))/(Gretpos(idi(i)-ntrem)+Gpos2(i-1)))+((Gretpos(idi(i)-ntrem)*Gpos2(i))/(Gretpos(idi(i)-ntrem)+Gpos2(i)))+(1/(Rret(idi(i)-ntrem)));
                    G(4*i-3,4*i+1)=-((Gretpos(idi(i)-ntrem)*Gpos1(i))/(Gretpos(idi(i)-ntrem)+Gpos1(i)));
                    G(4*i-1,4*i+2)=-Gneg1(i);
                    G(4*i,4*i+3)=-Gneg2(i);
                    G(4*i-3,4*i+4)=-((Gretpos(idi(i)-ntrem)*Gpos2(i))/(Gretpos(idi(i)-ntrem)+Gpos2(i)));
                endif
            endif
        %elseif idi(i)>nret && idi(i)<=narm %se ativo for armazenador
        else %se ativo for cabo crossbound
            G(4*i-2,4*i-2)=Gcross(idi(i)-narm)+Gneg1(i)+Gneg1(i-1)+((Gground(i)+Gground(i-1))/2);
            G(4*i-1,4*i-1)=Gcross(idi(i)-narm)+Gneg2(i)+Gneg2(i-1)+((Gground(i)+Gground(i-1))/2);
            G(4*i-2,4*i-1)=-Gcross(idi(i)-narm);
            if idi(i+1)>ntrem && idi(i+1)<=nret
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo e anterior ativo for retificadora
                    G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)))+((Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i,4*i)=((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)))+((Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                    G(4*i-2,4*i+3)=-Gneg1(i);
                    G(4*i-1,4*i+4)=-Gneg2(i);
                    G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
                else %se proximo ativo for retificadora e ativo anterior nao
                    G(4*i-3,4*i-3)=((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)))+Gpos1(i-1);
                    G(4*i,4*i)=((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)))+Gpos2(i-1);
                    G(4*i-3,4*i+1)=-((Gpos1(i)*Gretpos(idi(i+1)-ntrem))/(Gpos1(i)+Gretpos(idi(i+1)-ntrem)));
                    G(4*i-2,4*i+3)=-Gneg1(i);
                    G(4*i-1,4*i+4)=-Gneg2(i);
                    G(4*i,4*i+1)=-((Gpos2(i)*Gretpos(idi(i+1)-ntrem))/(Gpos2(i)+Gretpos(idi(i+1)-ntrem)));
                endif
            else
                if idi(i-1)>ntrem && idi(i-1)<=nret %se proximo ativo nao for retificadora e ativo anterior retificadora
                    G(4*i-3,4*i-3)=Gpos1(i)+((Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i,4*i)=Gpos2(i)+((Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem)));
                    G(4*i-3,4*i+1)=-Gpos1(i);
                    G(4*i-2,4*i+2)=-Gneg1(i);
                    G(4*i-1,4*i+3)=-Gneg2(i);
                    G(4*i,4*i+4)=-Gpos2(i);
                else %se proximo ativo e anterior nao for retificadora
                    G(4*i-3,4*i-3)=Gpos1(i)+Gpos1(i-1);
                    G(4*i,4*i)=Gpos2(i)+Gpos2(i-1);
                    G(4*i-3,4*i+1)=-Gpos1(i);
                    G(4*i-2,4*i+2)=-Gneg1(i);
                    G(4*i-1,4*i+3)=-Gneg2(i);
                    G(4*i,4*i+4)=-Gpos2(i);
                endif
            endif
        endif
    else %se ativo e o ultimo da linha
        if idi(i)<=ntrem %se ativo for trem
            G(4*i-2,4*i-2)=Gneg1(i-1);
            G(4*i-1,4*i-1)=Gneg2(i-1);
            if idi(i-1)>ntrem && idi(i-1)<=nret %se ativo anterior for retificadora
                G(4*i-3,4*i-3)=(Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem));
                G(4*i,4*i)=(Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem));
            else %se ativo anterior nao for retificadora
                G(4*i-3,4*i-3)=Gpos1(i-1);
                G(4*i,4*i)=Gpos2(i-1);
            endif
        elseif idi(i)>ntrem && idi(i)<=nret %se ativo for retificadora
            G(4*i-2,4*i-2)=(2*Gretneg(idi(i)-ntrem))+(1/(Rret(idi(i)-ntrem)))+Gterra(idi(i)-ntrem);
            G(4*i-1,4*i-1)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg1(i-1)+Gground(i-1)/2;
            G(4*i,4*i)=Gretneg(idi(i)-ntrem)+Gcret(idi(i)-ntrem)+Gneg2(i-1)+Gground(i-1)/2;
            G(4*i-3,4*i-2)=-(1/(Rret(idi(i)-ntrem)));
            G(4*i-2,4*i-1)=-Gretneg(idi(i)-ntrem);
            G(4*i-2,4*i)=-Gretneg(idi(i)-ntrem);
            G(4*i-1,4*i)=-Gcret(idi(i)-ntrem);
            if idi(i-1)>ntrem && idi(i-1)<=nret %se ativo anterior for retificadora
                G(4*i-3,4*i-3)=((Gretpos(idi(i)-ntrem)*Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos1(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))))+((Gretpos(idi(i)-ntrem)*Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/((Gretpos(idi(i)-ntrem)*Gpos2(i-1))+(Gretpos(idi(i)-ntrem)*Gretpos(idi(i-1)-ntrem))+(Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))))+(1/(Rret(idi(i)-ntrem)));
            else
                G(4*i-3,4*i-3)=((Gpos1(i-1)*Gretpos(idi(i)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i)-ntrem)))+((Gpos2(i-1)*Gretpos(idi(i)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i)-ntrem)))+(1/(Rret(idi(i)-ntrem)));
            endif
        %elseif idi(i)>nret && idi(i)<=narm %se ativo for armazenador
        else %se ativo for cabo crossbound
            G(4*i-2,4*i-2)=Gcross(idi(i)-narm)+Gneg1(i-1)+Gground(i-1)/2;
            G(4*i-1,4*i-1)=Gcross(idi(i)-narm)+Gneg2(i-1)+Gground(i-1)/2;
            G(4*i-2,4*i-1)=-Gcross(idi(i)-narm);
            if idi(i-1)>ntrem && idi(i-1)<=nret %se ativo anterior for retificadora
                G(4*i-3,4*i-3)=(Gpos1(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos1(i-1)+Gretpos(idi(i-1)-ntrem));
                G(4*i,4*i)=(Gpos2(i-1)*Gretpos(idi(i-1)-ntrem))/(Gpos2(i-1)+Gretpos(idi(i-1)-ntrem));
            else %se ativo anterior nao for retificadora
                G(4*i-3,4*i-3)=Gpos1(i-1);
                G(4*i,4*i)=Gpos2(i-1);
            endif
        endif
    endif
endfor
%montagem do resto da matriz de condutancia, uma vez que ate o momento j>i
%matriz de condutancia G(i,j)=G(j,i)
for i=1:(4*nativos)
      for j=1:(i-1)      %mapeando elementos a esquerda da diagonal principal
          G(i,j)=G(j,i); %fazendo elements a esquerda igual aos da direita
      endfor
endfor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
endfunction
