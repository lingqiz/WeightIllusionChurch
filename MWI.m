%% MWI Equal Weight Input

load('EqualWeightSimulation.mat');
inputCondition = [-0.5, -1.3, -1.5, -1.6, -1.9, -2.5, -3, -3.2];

% Mean Estimate (Effect of MWI)
inputWeight = 700; 
meanEst = mean(simulationDraws, 2);

% Plot mean estimate (log ratio & weight)
figure;

subplot(1, 2, 1);
plot(inputCondition, meanEst, '-o'); 

hold on;
plot([-4, 0], [0, 0], '--');

xlabel('Log Density Ratio');
ylabel('Log Weight Ratio');

yl = inputWeight .* exp(ylim);
subplot(1, 2, 2);
plot(inputCondition, inputWeight .* exp(meanEst), '-o');

hold on;
plot([-4, 0], [inputWeight, inputWeight], '--');

xlabel('Log Density Ratio');
ylabel('Estimated Weight');
ylim(yl);


figure;
for idx = 1 : length(inputCondition)
    subplot(4, 2, idx);
    histogram(simulationDraws(idx, :), 'BinWidth', 0.1, 'Normalization', 'probability');
    xlim([-3, 2]);
    title(num2str(inputCondition(idx)));
end

%% MWI Unequal Weight Input with Density Prior Centered at -1.95
figure; hold on;

load('UnequalWeightSimulation.mat');
inputCondition = [0, -0.05, -0.1, -0.15, -0.2];

meanEst = mean(simDraws, 2);
plot(inputCondition, meanEst, '-o');
plot([-4, 0], [0, 0], '--');

set(gca, 'XDir','reverse')
xlabel('Input Weight Ratio'); ylabel('Log Weight Ratio');
xlim([-0.21, 0.01]); ylim([-0.05, 0.13]);