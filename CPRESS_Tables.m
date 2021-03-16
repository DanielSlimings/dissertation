%% Compiling Contact Pressure Data ----------------------------------------
% Clear command line and memory
close all; clear; clc;

filename = ["fc" "sm" "mc"];
avg = [];

for i = 1:3
    for j = 1:5
        % Import CPRESS data from file
        CPRESS = importdata([char(filename(i)) num2str(20+j) '.rpt']);
        
        % Find range of CPRESS values
        n = find(CPRESS.textdata(:,5) == "Attached",1) + ...
            2:length(CPRESS.textdata);
        
        % Store CPRESS values from text data
        store = table(str2double(CPRESS.textdata(n,2)),...
            str2double(CPRESS.textdata(n,4)));
        store.Properties.VariableNames{1} = 'Node';
        store.Properties.VariableNames{2} = 'Value';
        [C,ia] = unique(store.Node);
        store = store(ia,:);
        
        % Convert frequency to contact percentage
        cpercent = length(find(store.Value ~= 0))/length(store.Value)*100;
        
        % Store final values
        avg = [avg; mean(store.Value) cpercent];
        
        % Clear variables for safety
        clear CPRESS n store frequency
    end
end

%% Theoretical Contact Pressure -------------------------------------------
RF = ([7.5233 8.1395 8.7622 9.3743 10]-7.5);
P  = RF/(0.125^2 - (pi/4)*0.025^2);

%% Plotting Contact Pressure Data -----------------------------------------

% Plot Total Average Pressure =============================================
figure(1)

plot(21:25,avg(1:5,1)*1e-3,'r--o'); hold on
plot(21:25,avg(6:10,1)*1e-3,'b--o'); hold on
plot(21:25,avg(11:15,1)*1e-3,'k--o'); hold on
plot(21:25,P,'g--o');

% PLOT THEORETICAL DATA AS CONFIRMATION OF MODEL %

set ( gca,'FontName','Times New Roman','FontSize',12,'xdir','reverse');
% title('Total Mean Contact Pressure');
ylabel('Contact Pressure (kPa)');
xlabel('Bolt Diameter (mm)'); xticks(21:1:25);
legend('Field Change','Seperate Model','Model Change','Theory');

% Plot Contact Percentage =================================================
figure(2)

plot(21:25,avg(1:5,2),'r--o'); hold on
plot(21:25,avg(6:10,2),'b--o'); hold on
plot(21:25,avg(11:15,2),'k--o');

set ( gca,'FontName','Times New Roman','FontSize',12,'xdir','reverse');
% title('Plate-to-Plate contact versus bolt diameter');
ylabel('Contact (%)'); ylim([0 100]);
xlabel('Bolt Diameter (mm)'); xticks(21:1:25);
legend('Field Change','Seperate Model','Model Change');
