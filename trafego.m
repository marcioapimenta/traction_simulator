global t S Ptrafego Vel m_via Ptrem pos num_trem ext_linha;

hd=floor(t/num_trem);%headway da linha

%%%%%%%montagem das matrizes S (posicao) e P(potencia) dos trens
for tc=1:t
    if pos(tc)>ext_linha
        sf1(tc)=2*ext_linha-pos(tc);
        via(tc)=2;
    else
        sf1(tc)=pos(tc);
        via(tc)=1;
    end
    %posicao, numero da via e potencia para o primeiro trem
    S(1,tc)=sf1(tc);
    m_via(1,tc)=via(tc);
    Ptrafego(1,tc)=Ptrem(tc); %negativo tracao e positivo freio
    Vel(1,tc)=vel(tc);
end

%atribuicao da posicao e numero da via para os demais trens
for i=2:num_trem
    for tv=hd+1:t
        S(i,tv)=S(i-1,tv-hd);
        m_via(i,tv)=m_via(i-1,tv-hd);
        Ptrafego(i,tv)=Ptrafego(i-1,tv-hd);
        Vel(i,tv)=Vel(i-1,tv-hd);
    end
    for tv=1:hd
        S(i,tv)=S(i-1,t-hd+tv);
        m_via(i,tv)=m_via(i-1,t-hd+tv);
        Ptrafego(i,tv)=Ptrafego(i-1,t-hd+tv);
        Vel(i,tv)=Vel(i-1,t-hd+tv);
    end
end
