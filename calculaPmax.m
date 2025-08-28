%rotina para calcular a potencia maxima de tracao possivel ao trem ao longo
%com o calculo da Rth percebida pelo trem ao longo de seu percurso, tem-se que
%a maxima potencia de tracao que ele pode consumir, ou seja, que o sistema e
%capaz de entregar e de Vth*Vth/4*Req
%como o calculo de Vth nao e trivial, esse valor pode ser admitido como sendo o
%intervalo entre o valor minimo e maximo para que o trem esteja em tracao plena,
%conforme normas EN50388 e EN50163, ou seja Umin2 e a*Ud

global Umax1 a Ud Reqfinal t Pmaxmin Pmaxmax;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%executa rotina de calculo de Rth percebido pelo trem ao longo do percurso
%calculaReq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo da potencia caso Vth seja o valor minimo e maximo, Umin2 e a*Ud
%calculo da corrente de curto circuito para ou casos, Vth/Req

for tint=1:t
    Pmaxminst(tint)=-(Umax1*Umax1)/(4*Reqfinal(tint,1));
    Pmaxmaxst(tint)=-(a*Ud*a*Ud)/(4*Reqfinal(tint,1));
    Iccminst(tint)=-Umax1/Reqfinal(tint,1);
    Iccmaxst(tint)=-(a*Ud)/Reqfinal(tint,1);
    Pmaxminct(tint)=-(Umax1*Umax1)/(4*Reqfinal(tint,2));
    Pmaxmaxct(tint)=-(a*Ud*a*Ud)/(4*Reqfinal(tint,2));
    Iccminct(tint)=-Umax1/Reqfinal(tint,2);
    Iccmaxct(tint)=-(a*Ud)/Reqfinal(tint,2);
end
