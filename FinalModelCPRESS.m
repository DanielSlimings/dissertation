%% Compiling Contact Pressure Data ----------------------------------------
% Clear command line and memory
close all; clear; clc;

filename = ["sm" "fc"];
avg = [];

for i = 1:2
    for j = 1:17
        % Import CPRESS data from file
        CPRESS = importdata([char(filename(i)) num2str(111+(j-1)*5) '.rpt']);
        
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

%% Plotting Contact Pressure Data -----------------------------------------

% Plot Total Average Pressure =============================================
figure(1)

plot(11.1:0.5:19.1,avg(1:17,1)*1e-6,'b-o'); hold on
plot(11.1:0.5:19.1,avg(18:34,1)*1e-6,'r-s'); hold on
xline(14.6,'--');

grid on;
set(gca,'FontName','Times New Roman','FontSize',12,'xdir','reverse');
ylabel('Contact Pressure (MPa)');
xlabel('Bolt Diameter (mm)'); xticks(11.1:2:19.1);
legend('Seperate Model', 'Field Change','Failure');

% Plot Contact Percentage =================================================
figure(2)

plot(11.1:0.5:19.1,avg(1:17,2),'b-o'); hold on
plot(11.1:0.5:19.1,avg(18:34,2),'r-s'); hold on
xline(14.6,'--');

grid on;
set(gca,'FontName','Times New Roman','FontSize',12,'xdir','reverse');
ylabel('Contact (%)');
xlabel('Bolt Diameter (mm)'); xticks(11.1:2:19.1);
legend('Seperate Model','Field Change','Failure');
