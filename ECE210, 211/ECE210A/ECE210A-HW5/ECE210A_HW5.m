%% Husam Almanakly | ECE210A HW 7

clc 
close all 
clear


M = importdata('StocksALL.csv')

dates = string(M.textdata(:,1))
comps = string(M.textdata(1,:))

DateObjs = {};
for i = 2:1:505
    DateObjs{i} = Date(dates(i));
    
end

stockObj = {}
for i = 2:1:6
    stockObj{i} = Stock(comps(i), DateObjs, M.data(:,i));
    create(stockObj{i}(1));
end






