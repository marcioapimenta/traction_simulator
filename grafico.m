%https://www.youtube.com/watch?v=ADfVc7ehE6k

##%grafico triplo
##figure
##subplot(3,1,1)
##estacao=['A';'B';'C';'D';'E';'F';'G';'H';'I';'J';'K';'L';'M';'N';'O';'P';'Q';'R';'S';'T';'U';'V';'W';'X';'W';'V';'U';'T';'S';'R';'Q';'P';'O';'N';'M';'L';'K';'J';'I';'H';'G';'F';'E';'D';'C';'B';'A'];
##plot(pos,Vfinal(1,:),'-k');
##%xlabel 'Distribuição das Estações [m]';
##ylabel 'Tensão [V]';
##grid on;
##axis([0 42022 650 950]);
##set(gca,'XTick',loc_est);
##set(gca,'XTickLabel',estacao);
##set(gca,'YTick',650:50:950);
##set(gca,'FontSize',14);
##subplot(3,1,2)
##estacao=['A';'B';'C';'D';'E';'F';'G';'H';'I';'J';'K';'L';'M';'N';'O';'P';'Q';'R';'S';'T';'U';'V';'W';'X';'W';'V';'U';'T';'S';'R';'Q';'P';'O';'N';'M';'L';'K';'J';'I';'H';'G';'F';'E';'D';'C';'B';'A'];
##plot(pos,Ifinal(1,:),'-k');
##%xlabel 'Distribuição das Estações [m]';
##ylabel 'Corrente [A]';
##grid on;
##axis([0 42022 -7500 9000]);
##set(gca,'XTick',loc_est);
##set(gca,'XTickLabel',estacao);
##set(gca,'YTick',-7500:3000:9000);
##set(gca,'FontSize',14);
##subplot(3,1,3)
##plot(pos,Etrem(1,:),'-k');
##xlabel 'Distribuição das Estações [m]';
##ylabel 'Estado do trem';
##grid on;
##axis([0 42022 0 4]);
##set(gca,'XTick',loc_est);
##set(gca,'XTickLabel',estacao);
##set(gca,'YTick',0:1:4);
##set(gca,'FontSize',14);

##%grafico simples
##figure
##plot(P');
##xlabel 'Passo de simulação';
##ylabel 'Potência requerida por todos os trens[W]';
##grid minor;
##axis([1 17858 -5500000 7500000]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',-5500000:1000000:7500000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(S(1:22,:)');
##xlabel 'Passo de simulação';
##ylabel 'Posição [m]';
##grid minor;
##axis([1 17858 0 22000]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0:1000:22000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(vel.*3.6,'-k');
##xlabel 'Passo de simulação';
##ylabel 'Velocidade [km/h]';
##grid minor;
##axis([1 17858 0 90]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0:10:90);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(P(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Potência requerida pelo trem [W]';
##grid minor;
##axis([1 17858 -5500000 7500000]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',-5500000:1000000:7500000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(sf1,'-k');
##xlabel 'Passo de simulação';
##ylabel 'Posição [m]';
##grid minor;
##axis([1 17858 0 22000]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0:1000:22000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(vel.*3.6,'-k');
##xlabel 'Passo de simulação';
##ylabel 'Velocidade [km/h]';
##grid minor;
##axis([0 380 0 90]);
##set(gca,'XTick',0:38:380);
##set(gca,'YTick',0:10:90);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(pos,'-k');
##xlabel 'Passo de simulação';
##ylabel 'Posição [m]';
##grid minor;
##axis([0 380 0 1400]);
##set(gca,'XTick',0:38:380);
##set(gca,'YTick',0:140:1400);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(P(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Potência requerida [W]';
##grid minor;
##axis([0 380 -6000000 7000000]);
##set(gca,'XTick',0:38:380);
##set(gca,'YTick',-6000000:1000000:7000000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(Vfinal(51,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Tensão [V]';
##grid minor;
##axis([1 17858 700 950]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',700:50:950);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(Ifinal(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Corrente [A]';
##grid minor;
##axis([1 17858 -7500 9000]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',-7500:500:9000);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(Ifinal(51,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Corrente [A]';
##grid minor;
##axis([1 17858 0 5500]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0:500:5500);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(Etrem(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Estado do trem 1';
##grid minor;
##axis([1 17858 0.5 3.5]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0.5:0.5:3.5);
##set(gca,'FontSize',20);

##%grafico simples
##figure
##plot(Eretificadora(12,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Estado da retificadora 12';
##grid minor;
##axis([1 17858 0 1.2]);
##set(gca,'XTick',0:1050:17858);
##set(gca,'YTick',0:0.6:1.2);
##set(gca,'FontSize',20);

##%grafico duplo
##figure
##plot(P(1,:),'-k');
##axis([3250 3480 -6000000 8000000]);
##set(gca,'XTick',3250:46:3480);
##set(gca,'YTick',-6000000:500000:8000000);
##set(gca,'FontSize',20);
##hold on;
##plot(Pfinal(1,:),'-r');
##ylabel 'Potência [W]';
##xlabel 'Passo de simulação';
##grid minor;
##axis([3250 3480 -6000000 8000000]);
##set(gca,'XTick',3250:46:3480);
##set(gca,'YTick',-6000000:1000000:8000000);
##set(gca,'FontSize',20);
##legend('Potência de marcha','Potência elétrica');

##%grafico duplo
##figure
##subplot(2,1,1);
##plot(P(1,:),'-k');
##hold on;
##plot(Pfinal(1,:),'-r');
##ylabel 'Potência [W]';
##xlabel 'Passo de simulação';
##grid minor;
##axis([3250 3480 -5500000 7500000]);
##set(gca,'XTick',3250:46:3480);
##set(gca,'YTick',-5500000:2000000:7500000);
##legend('Ptrem','Patual');
##set(gca,'FontSize',16);
##subplot(2,1,2);
##plot(Etrem(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Estado do trem';
##grid minor;
##axis([3250 3480 0 4]);
##set(gca,'XTick',3250:46:3480);
##set(gca,'YTick',0:1:4);
##set(gca,'FontSize',16);

##%grafico triplo - retirado do workspace 41t na pasta de resultados antigos
##figure
##subplot(3,1,1)
##plot(Vfinal(1,:),'-k');
##ylabel 'Tensão [V]';
##grid minor;
##axis([8000 10000 550 900]);
##set(gca,'XTick',8000:250:10000);
##set(gca,'YTick',550:50:900);
##set(gca,'FontSize',14);
##subplot(3,1,2)
##plot(P(1,:),'-k');
##hold on;
##plot(Pfinal(1,:),'-r');
##ylabel 'Potência [W]';
##grid minor;
##axis([8000 10000 -5500000 6000000]);
##set(gca,'XTick',8000:250:10000);
##set(gca,'YTick',-5500000:1500000:6000000);
##legend('Ptrem','Patual');
##set(gca,'FontSize',14);
##subplot(3,1,3)
##plot(Etrem(1,:),'-k');
##xlabel 'Passo de simulação';
##ylabel 'Estado do trem';
##grid minor;
##axis([8000 10000 0 4]);
##set(gca,'XTick',8000:250:10000);
##set(gca,'YTick',0:1:4);
##set(gca,'FontSize',14);

%grafico triplo
figure
subplot(3,1,1)
plot(Vfinal(34,:),'-k');
ylabel 'Tensão [V]';
grid minor;
axis([4000 4500 750 900]);
set(gca,'XTick',4000:50:4500);
set(gca,'YTick',750:50:900);
set(gca,'FontSize',14);
subplot(3,1,2)
plot(Ifinal(34,:),'-k');
ylabel 'Corrente [A]';
grid minor;
axis([4000 4500 0 5000]);
set(gca,'XTick',4000:50:4500);
set(gca,'YTick',0:1000:5000);
set(gca,'FontSize',14);
set(gca,'FontSize',14);
subplot(3,1,3)
plot(Eretificadora(12,:),'-k');
xlabel 'Passo de simulação';
ylabel 'Estado da retificadora 12';
grid minor;
axis([4000 4500 0 1.2]);
set(gca,'XTick',4000:50:4500);
set(gca,'YTick',0:0.5:1.2);
set(gca,'FontSize',14);
