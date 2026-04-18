clc; clear; close all;

%% ================================
% Number of samples
%% ================================
N = 150;

%% ================================
% STEP 1: Sulfur Data (ONLY INPUT)
%% ================================
Sulfur_Content = 2 + (6-2).*rand(N,1);

%% ================================
% STEP 2: Derived Properties (ONLY Sulfur-Based)
%% ================================
Surface_Area = 40 + 8*Sulfur_Content + randn(N,1)*3;
Pore_Volume = 0.2 + 0.02*Sulfur_Content + randn(N,1)*0.01;
Porosity = 30 + 5*Sulfur_Content + randn(N,1)*2;

%% ================================
% STEP 3: SEM Analysis (Surface Morphology)
%% ================================
SEM_Texture_Index = 0.7*Surface_Area + 0.3*Porosity + randn(N,1)*2;

%% ================================
% STEP 4: XRD Analysis (Crystallinity)
%% ================================
Crystallinity_Index = 20 + 10*Sulfur_Content + randn(N,1)*3;
Crystallinity_Index = max(0, min(100, Crystallinity_Index));

%% ================================
% Create Table for Base Data
%% ================================
CoalSlurryData = table(Sulfur_Content, Surface_Area, Pore_Volume, ...
                       Porosity, SEM_Texture_Index, Crystallinity_Index);

%% ================================
% DISPLAY RESULTS (COMMAND WINDOW)
%% ================================
disp('--- Sulfur-Based Coal Slurry Dataset ---');
disp(CoalSlurryData);

disp('--- SEM Analysis Result ---');
fprintf('Average SEM Texture Index: %.2f\n', mean(SEM_Texture_Index));
fprintf('Max SEM Texture Index: %.2f\n', max(SEM_Texture_Index));

disp('--- XRD Analysis Result ---');
fprintf('Average Crystallinity Index: %.2f\n', mean(Crystallinity_Index));
fprintf('Max Crystallinity Index: %.2f\n', max(Crystallinity_Index));

%% ================================
% LINE PLOTS (SEM & XRD VISUALIZATION)
%% ================================
figure;
[S_sorted, idx] = sort(Sulfur_Content);
SA_sorted = Surface_Area(idx);
SEM_sorted = SEM_Texture_Index(idx);
Cryst_sorted = Crystallinity_Index(idx);

subplot(2,2,1);
plot(S_sorted, SA_sorted, '-o', 'LineWidth', 2);
xlabel('Sulfur Content (%)'); ylabel('Surface Area');
title('Sulfur vs Surface Area'); grid on;

subplot(2,2,2);
plot(S_sorted, SEM_sorted, '-s', 'LineWidth', 2);
xlabel('Sulfur Content (%)'); ylabel('SEM Texture Index');
title('SEM Analysis (Surface Morphology)'); grid on;

subplot(2,2,3);
plot(S_sorted, Cryst_sorted, '-d', 'LineWidth', 2);
xlabel('Sulfur Content (%)'); ylabel('Crystallinity Index');
title('XRD Analysis (Crystallinity)'); grid on;

subplot(2,2,4);
plot(S_sorted, SEM_sorted, '-o', 'LineWidth', 2); hold on;
plot(S_sorted, Cryst_sorted, '-x', 'LineWidth', 2);
xlabel('Sulfur Content (%)'); ylabel('Index Value');
title('SEM vs XRD Comparison'); legend('SEM Texture','Crystallinity'); grid on;

%% ================================
% STEP 5: MODIFICATION PROCESS
%% ================================
Temperature = 400 + (800-400).*rand(N,1);   % °C
Activation_Time = 30 + (120-30).*rand(N,1); % minutes
Chemical_Ratio = 0.5 + (2-0.5).*rand(N,1);  % ratio

Mod_Surface_Area = Surface_Area + 0.05*Temperature + 5*Chemical_Ratio + randn(N,1)*5;
Mod_Pore_Volume = Pore_Volume + 0.0005*Temperature + 0.01*Chemical_Ratio + randn(N,1)*0.01;
Mod_Porosity = Porosity + 0.02*Temperature + 2*Chemical_Ratio + randn(N,1)*2;
Adsorption_Capacity = 10 + 0.1*Mod_Surface_Area + 20*Mod_Pore_Volume + randn(N,1)*2;

disp('--- MODIFICATION PROCESS RESULTS ---');
ModifiedData = table(Temperature, Activation_Time, Chemical_Ratio, ...
                     Mod_Surface_Area, Mod_Pore_Volume, Mod_Porosity, Adsorption_Capacity);
disp(ModifiedData);

disp('--- Modification Summary ---');
fprintf('Avg Modified Surface Area: %.2f\n', mean(Mod_Surface_Area));
fprintf('Max Adsorption Capacity: %.2f\n', max(Adsorption_Capacity));

% Separate Plots for Modification
[T_sorted, idx2] = sort(Temperature);
MSA_sorted = Mod_Surface_Area(idx2);
MPV_sorted = Mod_Pore_Volume(idx2);
MPO_sorted = Mod_Porosity(idx2);
Ads_sorted = Adsorption_Capacity(idx2);

figure; plot(T_sorted, MSA_sorted, '-o', 'LineWidth', 2); xlabel('Temperature (°C)'); ylabel('Modified Surface Area'); title('Heat Treatment Effect on Surface Area'); grid on;
figure; plot(T_sorted, MPV_sorted, '-s', 'LineWidth', 2); xlabel('Temperature (°C)'); ylabel('Modified Pore Volume'); title('Heat Treatment Effect on Pore Volume'); grid on;
figure; plot(T_sorted, MPO_sorted, '-d', 'LineWidth', 2); xlabel('Temperature (°C)'); ylabel('Modified Porosity'); title('Heat Treatment Effect on Porosity'); grid on;
figure; plot(T_sorted, Ads_sorted, '-^', 'LineWidth', 2); xlabel('Temperature (°C)'); ylabel('Adsorption Capacity'); title('Adsorption Performance After Modification'); grid on;

%% ================================
% STEP 6: POROUS ADSORBENT ADSORPTION (Langmuir & Freundlich)
%% ================================
C = linspace(0,50,50);  % concentration mg/L
qmax = max(Ads_sorted);  KL = 0.1;  KF = 0.5;  n = 2;
q_langmuir = (qmax * KL * C)./(1 + KL * C);
q_freundlich = KF * C.^(1/n);

disp('--- ADSORPTION ISOTHERM RESULTS ---');
disp(table(C', q_langmuir', q_freundlich', 'VariableNames', {'Concentration_mg_L','Langmuir_q_mg_g','Freundlich_q_mg_g'}));
fprintf('Max Langmuir adsorption: %.2f mg/g\n', max(q_langmuir));
fprintf('Max Freundlich adsorption: %.2f mg/g\n', max(q_freundlich));

figure; plot(C, q_langmuir, '-o', 'LineWidth', 2); xlabel('Concentration (mg/L)'); ylabel('q (mg/g)'); title('Langmuir Isotherm'); grid on;
figure; plot(C, q_freundlich, '-s', 'LineWidth', 2); xlabel('Concentration (mg/L)'); ylabel('q (mg/g)'); title('Freundlich Isotherm'); grid on;
figure; plot(C, q_langmuir, '-o', 'LineWidth', 2); hold on; plot(C, q_freundlich, '-s', 'LineWidth', 2); xlabel('Concentration (mg/L)'); ylabel('q (mg/g)'); title('Langmuir vs Freundlich'); legend('Langmuir','Freundlich'); grid on;

%% ================================
% STEP 7: HEAVY METAL REMOVAL SIMULATION
%% ================================

% Parameters
Contact_Time = linspace(10, 120, 50);  % minutes
pH = linspace(3, 9, 50);               % pH value
C_init = linspace(5, 50, 50);          % initial heavy metal concentration mg/L

% Removal efficiency (%) model (example sigmoid response)
Removal_Efficiency = @(C,t,pH) 100 * (1 - exp(-0.05*t)) .* (1 - exp(-0.1*C)) .* (1 - 0.05*abs(7-pH));

%% Evaluate removal efficiency for each parameter separately

% 1) Effect of Contact Time
Removal_vs_Time = Removal_Efficiency(mean(C_init), Contact_Time, 7);
figure;
plot(Contact_Time, Removal_vs_Time, '-o','LineWidth',2);
xlabel('Contact Time (min)'); ylabel('Removal Efficiency (%)');
title('Effect of Contact Time on Heavy Metal Removal'); grid on;

% 2) Effect of pH
Removal_vs_pH = Removal_Efficiency(mean(C_init), 60, pH);
figure;
plot(pH, Removal_vs_pH, '-s','LineWidth',2);
xlabel('pH'); ylabel('Removal Efficiency (%)');
title('Effect of pH on Heavy Metal Removal'); grid on;

% 3) Effect of Initial Concentration
Removal_vs_C = Removal_Efficiency(C_init, 60, 7);
figure;
plot(C_init, Removal_vs_C, '-d','LineWidth',2);
xlabel('Initial Concentration (mg/L)'); ylabel('Removal Efficiency (%)');
title('Effect of Initial Concentration on Heavy Metal Removal'); grid on;

% Optional: Final table combining adsorption capacity and removal efficiency at mean conditions
Final_Results = table(mean(Ads_sorted)*ones(50,1), Removal_vs_Time', Removal_vs_pH', Removal_vs_C', ...
                      'VariableNames', {'Adsorption_Capacity_mg_g','Removal_vs_Time','Removal_vs_pH','Removal_vs_Concentration'});
disp('--- FINAL HEAVY METAL REMOVAL RESULTS ---');
disp(Final_Results);