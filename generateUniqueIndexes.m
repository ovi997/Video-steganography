function [idxs] = generateUniqueIndexes(maxVal, numVal)

idxs = unique(randi((maxVal),[1, numVal]));

while true
    if length(idxs) == numVal
        break
    else
        idxs = unique([idxs randi((maxVal),[1, numVal-length(idxs)])]);
    end
end

end