% Extracting Yahoo Data
% Michael Beven
% 20151016

clear;
close all;

%% Define Parameters

% Start and End Dates
startDate = '2015-08-1';
endDate = '2015-08-31';

% extract data
symbol = 'IBM';
[raw_data] = fetch(yahoo,symbol,startDate,endDate);
raw_data2 = double(raw_data);

% create headers
headers = {'Open','High','Low','Close','Volume', 'Adj_Close'};

% turn to financial time series
% tsdata = fints(raw_data(:,1),raw_data(:,2:end),headers);

% convert serial date number to date
date_vector = datestr(raw_data(:,1),'yyyy-mm-dd');


% attach headers to data
% data = dataset({raw_data,headers{:}});

