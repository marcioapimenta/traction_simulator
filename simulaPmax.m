%rotina para calcular a potencia maxima de tracao possivel ao trem ao longo
%com o calculo da Rth percebida pelo trem ao longo de seu percurso, tem-se que
%a maxima potencia de tracao que ele pode consumir, ou seja, que o sistema e
%capaz de entregar e de Vth*Vth/4*Req
%como o calculo de Vth nao e trivial, esse valor pode ser admitido como sendo o
%intervalo entre o valor minimo e maximo para que o trem esteja em tracao plena,
%conforme normas EN50388 e EN50163, ou seja Umin2 e a*Ud
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%executa rotina de calculo de Rth percebido pelo trem ao longo do percurso
parametrosReq;
calculaReq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo da potencia caso Vth seja o valor minimo e maximo, Umin2 e a*Ud
%calculo da corrente de curto circuito para ou casos, Vth/Req
%Reqfinal
%coluna 1 - sem levar em conta impedancias dos trens vindas da simulacao eletrica
%coluna 2 - levando em conta impedancias dos trens
for tint=1:t
    Pmaxmin(consideratrens+1,tint)=-(Umax1*Umax1)/(4*Reqfinal(tint,consideratrens+1));
    Pmaxmax(consideratrens+1,tint)=-(a*Ud*a*Ud)/(4*Reqfinal(tint,consideratrens+1));
    Iccmin(tint,consideratrens+1)=-Umax1/Reqfinal(tint,consideratrens+1);
    Iccmax(tint,consideratrens+1)=-(a*Ud)/Reqfinal(tint,consideratrens+1);
end
