function data = normalize_data(data)
[~, n] = size(data);  
for i = 1:n
    data(:, i) = data(:, i) / norm(data(:, i));  
end
