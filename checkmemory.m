function mem = checkmemory(var)

if ischar(var)
    y = evalin('caller',['whos(''' var ''');']);
    mem = y.bytes;
else
    mem = var;
end

s = floor(log10(mem)/3);

denom = {'B','KB','MB','GB'};

if s < 4
    fprintf(['%7.3f ' denom{s+1} '\n'],mem/1000^s);
else
    fprintf(['%5.0e ' denom{end} '\n'],mem/1E9);
end
