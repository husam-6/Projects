classdef Stock
    properties (Access = private)
        symbol;
        Dates;
        returns;
    end

    methods
        function obj = Stock(name, cellArr, stockArr)
            obj.symbol = name; 
            obj.Dates = cellArr; 
            
            for i = 2:1:504
                obj.returns(i-1) = (stockArr(i) - stockArr(i-1))/(stockArr(i-1));
            end     
        end
        
        function plots = create(obj)
            figure
            x = 1:503;
            plot(x,obj.returns)
            title("Daily Stock Returns")
            first = obj.Dates{2};
            middle = obj.Dates{250};
            last = obj.Dates{504};
            xlim([0 504]);
            xticks([2 250 504]);
            xticklabels([report(first), report(middle), report(last)])
            xlabel("Date")
            ylabel("Stock Returns for " + obj.symbol)
        end
        
    end





end
