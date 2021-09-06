classdef Date
    properties (Access = private)
        year;
        month;
        day;
    end
    properties (Constant)
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    end
    methods
        function obj = Date(x)
            newString = split(x, '/');
            obj.month = double(newString(1));
            obj.day = double(newString(2));
            obj.year = double(newString(3));
        end
        
        function out = report(obj)
            month = obj.month;
            out = (string(obj.months(month)) + ". " + string(obj.day) + ", " + string(obj.year));
        end
    end
end