// A simple JSON Writer

function JSON = JSONWrite(s)
    if isstruct(s) || (typeof(s) == "state-space") then
        fields = fieldnames(s)';
        NF = size(fields)(2);
        buf = "{";
        
        for i = 1:NF
            if(i > 1)
                buf = buf + ",";
            end
            
            buf = buf + msprintf('""%s"":', fields(i));
            if(isstruct(s)) then
                val = getfield(i+2, s);
            else
                val = getfield(i+1,s);
            end
            
            buf = buf + JSONWrite(val);
        end
        buf = buf + "}";
        JSON = buf;
    elseif type(s) == 4 then //boolean
        if s then
            JSON = "true";
        else
            JSON = "false";
        end
    elseif (type(s) == 1) && (size(s) == [1 1]) then
        if round(s) == s then
            JSON = msprintf("%d", s);
        else
            JSON = msprintf("%f", s);
        end
    elseif type(s) == 10 then
        JSON = msprintf('""%s""', s);
    elseif typeof(s) == "ce" then
        buf = "[";
        N = size(s)(1);
        if N == 1 then N = size(s)(2); end
        for i = 1:N
            if i > 1 then
                buf = buf + ",";
            end
            if size(s) > [1 1] then
                buf = buf + JSONWrite(s{i,:});
            else
                buf = buf + JSONWrite(s{i});
            end
        end
        buf = buf + "]";
        JSON = buf;
    elseif typeof(s) == "polynomial" then
        temp = coeff(s);
        N = length(temp);
        for i = 1:N do
            if i == 1 then
                buf = ascii(34) + string(temp(i));
            else
                if temp(i) > 0 then
                    buf = buf + msprintf(" + %s*s^%d", string(temp(i)), i-1);
                else
                    buf = buf + msprintf(" %s*s^%d", string(temp(i)), i-1);
                end
            end
        end
        JSON = buf + ascii(34);
    elseif ismatrix(s) then
        buf = "[";
        N = size(s)(1);
        if N == 1 then N = size(s)(2); end
        for i = 1:N
            if i > 1 then
                buf = buf + ",";
            end
            if size(s) > [1 1] then
                buf = buf + JSONWrite(s(i,:));
            else
                buf = buf + JSONWrite(s(i));
            end
        end
        buf = buf + "]";
        JSON = buf;
    else
        JSON = "{}";
    end
endfunction
