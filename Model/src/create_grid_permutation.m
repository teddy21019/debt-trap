
    function grid_permutaion = create_grid_permutation(betas, delta_1s, delta_2s)
        [Beta, Delta_1, Delta_2] = meshgrid(betas, delta_1s, delta_2s);

        % Reshape the arrays into column vectors
        Beta = reshape(Beta, [], 1);
        Delta_1 = reshape(Delta_1, [], 1);
        Delta_2 = reshape(Delta_2, [], 1);

        % Concatenate the column vectors into a matrix
        grid_permutaion = [Beta, Delta_1, Delta_2];
    end
