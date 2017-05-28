% SAMPLE ENTROPY - EHG

% sample entropy measures level of regularity/predictability
% pre-term < 37th week (high regularity/predictability) -> low SE
% term > 37th week 
% early < 26th week
% late > 26th week

% high entropy -> low regularity/predictability ^^^^^^^^^^
% low entropy -> high regularity/predictability ^--^--^--^

% -----------------------------------------------LOADING
load('tpehg1007m.mat'); % preterm-late
sigPL = val(10,:);
load('tpehg1163m.mat'); % preterm-early
sigPE = val(10,:);
load('tpehg1027m.mat'); % term-late
sigTL = val(10,:);
load('tpehg1130m.mat'); % term-early S3
sigTE = val(10,:);
load('tpehg1130m.mat'); % term-early S2
sigTES2 = val(6,:);

% -----------------------------------------------CALCULATION
m = 3; % window length
r = 0.15; % tolerance

[ePL,se,A,B] = sampen(sigPL,m,r,1,0,0);
[ePE,se,A,B] = sampen(sigPE,m,r,1,0,0);
[eTL,se,A,B] = sampen(sigTL,m,r,1,0,0);
[eTE,se,A,B] = sampen(sigTE,m,r,1,0,0);
[eTES2,se,A,B] = sampen(sigTES2,m,r,1,0,0);

disp(['Preterm late PL SE: ' num2str(ePL(m))]);
disp(['Preterm early PE SE: ' num2str(ePE(m))]);
disp(['Term late TL SE: ' num2str(eTL(m))]);
disp(['Term early TE SE: ' num2str(eTE(m))]);
disp(['Term early TE S2 SE: ' num2str(eTES2(m))]);

% -----------------------------------------------SCATTER PLOT
x = [31, 22, 31, 23];
y = [ePL(m), ePE(m), eTL(m), eTE(m)];
plot(x,y,'*'); xlabel('Week'), ylabel('SE'); title('Sample entropies'); hold on;
xlim([20 40]);
ylim([0.3 1.5]);
text(x(1),y(1),' \leftarrow pre-term late R1007');
text(x(2),y(2),' \leftarrow pre-term early R1163');
text(x(3),y(3),' \leftarrow term late R1027');
text(x(4),y(4),' \leftarrow term early R1130');