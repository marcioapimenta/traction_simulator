%rotina para calcular a resistencia equivalente percebida pelos trens ao longo
%do percurso apos a simulacao eletrica concluida, tomando o trem 1 como base
%para calculo da Req vista por ele com todos os outros operando, de acordo com
%quantidade deles que foi simulado na eletrica
global Rret
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%de posse da tensao e corrente de cada trem, calcular sua resistencia equivalente
%em cada instante da simulacao eletrica
for tint=241:241
    for i=1:nativos
        if id(i,tint)<=ntrem      %trem
            if P(id(i,tint),tint)>0 %se trem freando, condutancia "invertida", negativa
                Gtrem(id(i,tint),tint)=-1/(abs(Vfinal(id(i,tint-1),tint)/Ifinal(id(i,tint-1),tint)));
            else
                Gtrem(id(i,tint),tint)=1/(abs(Vfinal(id(i,tint-1),tint)/Ifinal(id(i,tint-1),tint)));
            endif
        elseif id(i,tint)>ntrem && id(i,tint)<=nret %retificadora
            if Eretificadora(id(i,tint)-ntrem,tint)==0 %retificadora desligada
                Rret(id(i,tint)-ntrem)=(Vfinal(id(i,tint-1))*(((Ud0(id(i,tint)*Ud)-(Ud*Ud))/Pret(id(i-ntrem)))))/Ud0(id(i,tint));
            else                                       %retificadora ligada
                Rret(id(i,tint)-ntrem)=((Ud0(id(i,tint)-ntrem)*Ud)-(Ud*Ud))/Pret(id(i,tint)-ntrem);
            endif
        endif
    endfor
    for k=1:ntrem
        Ieq=zeros(4*nativos,1);
        i=find(id(:,tint)'==k);
        if m_via(k,tint)==1
            Ieq(4*i-3)=1;
            Ieq(4*i-2)=-1;
            pp=4*i-3;
            pn=4*i-2;
        else
            Ieq(4*i-1)=-1;
            Ieq(4*i)=1;
            pp=4*i;
            pn=4*i-1;
        end
        if consideratrens==1
            Geq=montaGReq(k,Sc(:,tint)',id(:,tint)',Gtrem(:,tint)',m_via(:,tint)');
        else
            Geq=montaG(Sc(:,tint)',id(:,tint)');
        endif
        Veq=Geq\Ieq;
        Req(k)=Veq(pp)-Veq(pn);
    endfor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %armazenamento de variaveis
    %Reqst - valores sem considerar a impedancia dos outros trens que rodam no sistema
    %Reqct - valores considerarando a impedancia dos outros trens que rodam no sistema
    if consideratrens==0
        Reqst(:,tint)=Req';
    else
        Reqct(:,tint)=Req';
    endif
    tint
endfor
