% Importing connical data
A = csvread(fullfile('Nosecone Drag Data','Conical','Conical_5_LB.CSV'),1,0);
Machdata = A(:,1);
CD_Conical_5_LB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Conical','Conical_8_LBR.CSV'),1,0);
CD_Conical_8_LBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Conical','Conical_12_NB.CSV'),1,0);
CD_Conical_12_NB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Conical','Conical_18_UBR.CSV'),1,0);
CD_Conical_18_UBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Conical','Conical_25_UB.CSV'),1,0);
CD_Conical_25_UB = A(:,3);

% Plot Conical Data
plot(Machdata(1:600),CD_Conical_5_LB(1:600),Machdata(1:600),CD_Conical_8_LBR(1:600), Machdata(1:600),CD_Conical_12_NB(1:600), Machdata(1:600), CD_Conical_18_UBR(1:600), Machdata(1:600),CD_Conical_25_UB(1:600))
legend('5 inch','8 inch','12 inch','18 inch','25 inch')
title('Conical Nose Cone Drag Data')
xlabel('Mach')
ylabel('Drag Coefficient')
%% 
% Drag data for Ogive

% Importing connical data
A = csvread(fullfile('Nosecone Drag Data','Ogive','Ogive_5_LB.CSV'),1,0);
Machdata = A(:,1);
CD_Ogive_5_LB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Ogive','Ogive_8_LBR.CSV'),1,0);
CD_Ogive_8_LBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Ogive','Ogive_12_NB.CSV'),1,0);
CD_Ogive_12_NB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Ogive','Ogive_18_UBR.CSV'),1,0);
CD_Ogive_18_UBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Ogive','Ogive_25_UB.CSV'),1,0);
CD_Ogive_25_UB = A(:,3);

% Plot Conical Data
plot(Machdata(1:600),CD_Ogive_5_LB(1:600),Machdata(1:600),CD_Ogive_8_LBR(1:600), Machdata(1:600),CD_Ogive_12_NB(1:600), Machdata(1:600), CD_Ogive_18_UBR(1:600), Machdata(1:600),CD_Ogive_25_UB(1:600))
legend('5 inch','8 inch','12 inch','18 inch','25 inch')
title('Ogive Nose Cone Drag Data')
xlabel('Mach')
ylabel('Drag Coefficient')


%% 
% Drag data for Power_Series

% Importing connical data
A = csvread(fullfile('Nosecone Drag Data','PowerSeries','Power_Series_5_LB.CSV'),1,0);
Machdata = A(:,1);
CD_Power_Series_5_LB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','PowerSeries','Power_Series_8_LBR.CSV'),1,0);
CD_Power_Series_8_LBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','PowerSeries','Power_Series_12_NB.CSV'),1,0);
CD_Power_Series_12_NB = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','PowerSeries','Power_Series_18_UBR.CSV'),1,0);
CD_Power_Series_18_UBR = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','PowerSeries','Power_Series_25_UB.CSV'),1,0);
CD_Power_Series_25_UB = A(:,3);

% Plot Conical Data
plot(Machdata(1:600),CD_Power_Series_5_LB(1:600),Machdata(1:600),CD_Power_Series_8_LBR(1:600), Machdata(1:600),CD_Power_Series_12_NB(1:600), Machdata(1:600), CD_Power_Series_18_UBR(1:600), Machdata(1:600),CD_Power_Series_25_UB(1:600))
legend('5 inch','8 inch','12 inch','18 inch','25 inch')
title('Power Series Nose Cone Drag Data')
xlabel('Mach')
ylabel('Drag Coefficient')
%% 

% Analysis of different shaped nose cones using 12 inch nose cone

plot(Machdata(1:600),CD_Conical_12_NB(1:600),Machdata(1:600),CD_Ogive_12_NB(1:600), Machdata(1:600),CD_Power_Series_12_NB(1:600))
legend('Conical', 'Ogive', 'Power Series')
title('Nose Cone Drag For different Shapes')
xlabel('Mach')
ylabel('Drag Coefficient')

%% All shapes and lengths in One
A = csvread(fullfile('Nosecone Drag Data','Von Karman','von'),1,0);
CD_Power_Series_25_UB = A(:,3);

plot(Machdata(1:600),CD_Conical_5_LB(1:600),Machdata(1:600),CD_Conical_8_LBR(1:600), Machdata(1:600),CD_Conical_12_NB(1:600), Machdata(1:600), CD_Conical_18_UBR(1:600), Machdata(1:600),CD_Conical_25_UB(1:600),Machdata(1:600),CD_Ogive_5_LB(1:600),Machdata(1:600),CD_Ogive_8_LBR(1:600), Machdata(1:600),CD_Ogive_12_NB(1:600), Machdata(1:600), CD_Ogive_18_UBR(1:600), Machdata(1:600),CD_Ogive_25_UB(1:600),Machdata(1:600),CD_Power_Series_5_LB(1:600),Machdata(1:600),CD_Power_Series_8_LBR(1:600), Machdata(1:600),CD_Power_Series_12_NB(1:600), Machdata(1:600), CD_Power_Series_18_UBR(1:600), Machdata(1:600),CD_Power_Series_25_UB(1:600))
legend('5 inch Conical','8 inch Conical','12 inch Conical','18 inch Conical','25 inch Conical','5 inch Ogive','8 inch Ogive','12 inch Ogive','18 inch Ogive','25 inch Ogive','5 inch Power Series','8 inch Power Series','12 inch Power Series','18 inch Power Series','25 inch Power Series')
title('Conical Nose Cone Drag Data')
xlabel('Mach')
ylabel('Drag Coefficient')

%% Surface finish data

A = csvread(fullfile('Nosecone Drag Data','Surface Finish','Power_Series_12_polished.CSV'),1,0);
Machdata = A(:,1);
Power_Series_12_polished = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Surface Finish','Power_Series_12_smooth_paint.CSV'),1,0);
Power_Series_12_smooth_paint = A(:,3);

A = csvread(fullfile('Nosecone Drag Data','Surface Finish','Power_Series_12_very_rough.CSV'),1,0);
Power_Series_12_very_rough = A(:,3);

plot(Machdata(1:600), CD_Power_Series_12_NB(1:600), Machdata(1:600), Power_Series_12_polished(1:600),Machdata(1:600),Power_Series_12_smooth_paint(1:600), Machdata(1:600),Power_Series_12_very_rough(1:600))
legend('Perfect Surface', 'Polished', 'smooth paint','very rough')
title('Nose Cone Drag For different Surface Finishes')
xlabel('Mach')
ylabel('Drag Coefficient')
