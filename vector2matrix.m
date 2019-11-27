function new_mat = vector2matrix(vec,cols)
% puts vector elements into different columns of a matrix with cols columns
v_size = size(vec);
max_rows = v_size(1)/cols;

vec_index=1;

new_mat = zeros(max_rows,cols);

for mat_row = 1:max_rows
    for col =  1:cols
        new_mat(mat_row,col) = vec(vec_index);
        vec_index = vec_index + 1;
    end
end

end