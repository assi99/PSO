function [best_transform, all_final_particles, positionHistory, pareto_log] = pso(features, mesh)
    nVars = 6;
    nParticles = 30;
    maxIters = 50;
    noImproveLimit = 5;

    lb = [0.8, 0.8, 0.8, -20, -20, -0.3];
    ub = [1.2, 1.2, 1.2,  20,  20,  0.3];

    w = 0.6; c1 = 1.8; c2 = 1.8;

    positions = lb + rand(nParticles, nVars) .* (ub - lb);
    velocities = (rand(nParticles, nVars) - 0.5) .* (ub - lb) * 0.2;
    pBest = positions;
    pBestScores = zeros(nParticles,1);
    pareto_log = zeros(maxIters, 3);  % [area, inertia, symmetry]

    positionHistory = zeros(maxIters, nVars);
    fitnessStdHistory = zeros(maxIters,1);
    gBestHistory = zeros(maxIters, 1);

    % Initial evaluation
    for i = 1:nParticles
        pBestScores(i) = fitness_function(positions(i,:), mesh, features);
    end
    [gBestScore, idx] = min(pBestScores);
    gBest = pBest(idx,:);
    stagnantCount = 0;

    figure(99); clf; hold on;
    title('Convergence Plot'); xlabel('Iteration'); ylabel('Best Fitness'); grid on;

    figure(199); clf;
    title('Pareto Front'); xlabel('Area'); ylabel('Inertia'); zlabel('Symmetry');
    grid on; view(3);

    for iter = 1:maxIters
        scores = zeros(nParticles,1);

        for i = 1:nParticles
            velocities(i,:) = w*velocities(i,:) + ...
                              c1*rand*(pBest(i,:) - positions(i,:)) + ...
                              c2*rand*(gBest - positions(i,:));
            positions(i,:) = min(max(positions(i,:) + velocities(i,:), lb), ub);

            scores(i) = fitness_function(positions(i,:), mesh, features);
            if scores(i) < pBestScores(i)
                pBest(i,:) = positions(i,:);
                pBestScores(i) = scores(i);
                if scores(i) < gBestScore
                    gBest = pBest(i,:);
                    gBestScore = scores(i);
                    stagnantCount = 0;  % reset
                end
            end
        end

        % If stagnant too long → mutate gBest slightly
        if stagnantCount >= noImproveLimit
            fprintf("[Mutation] gBest stagnant. Injecting mutation.\n");
            mutation = 0.01 * (ub - lb) .* (rand(1,nVars) - 0.5);
            gBest = min(max(gBest + mutation, lb), ub);
            stagnantCount = 0;
        end

        % Diversity tracking
        fitness_std = std(scores);
        fitnessStdHistory(iter) = fitness_std;
        gBestHistory(iter) = gBestScore;
        positionHistory(iter,:) = gBest;
        stagnantCount = stagnantCount + 1;

        % Pareto logging
        [area, inertia, symmetry, ~] = analyze_fitness_terms(gBest, mesh, features);
        pareto_log(iter,:) = [area, inertia, symmetry];

        % Pareto plot
        figure(199);
        scatter3(pareto_log(1:iter,1), pareto_log(1:iter,2), pareto_log(1:iter,3), ...
                 50, 'filled'); hold on;
        drawnow;

        % Stagnation rescue
        if fitness_std < 1e-4
            warning('Low diversity detected. Injecting noise.');
            rand_idx = randperm(nParticles, floor(nParticles/2));
            velocities(rand_idx,:) = (rand(length(rand_idx), nVars) - 0.5) .* (ub - lb) * 0.5;
            jitter = 0.01 * (ub - lb) .* (rand(nParticles, nVars) - 0.5);
            positions = min(max(positions + jitter, lb), ub);
        end

        % Convergence plot
        figure(99);
        plot(1:iter, gBestHistory(1:iter), 'b-', 'LineWidth', 1.5);
        drawnow;

        fprintf("Iter %2d | Best Score: %.4f | Std Dev: %.4f\n", iter, gBestScore, fitness_std);
    end

    figure(101); clf;
    plot(fitnessStdHistory, 'r-', 'LineWidth', 1.5);
    title('Fitness Score Std Dev per Iteration');
    xlabel('Iteration'); ylabel('Std Dev');
    grid on;

    best_transform = gBest;
    all_final_particles = pBest;
end
