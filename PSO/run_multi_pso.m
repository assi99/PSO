function all_runs = run_multi_pso(mesh, features, num_runs)
    all_runs = cell(num_runs, 1);
    for i = 1:num_runs
        fprintf('\n Running PSO %d of %d\n', i, num_runs);
        [best, particles, history, pareto] = pso(features, mesh);
        all_runs{i}.best = best;
        all_runs{i}.particles = particles;
        all_runs{i}.history = history;
        all_runs{i}.pareto = pareto;
    end
    save('multi_pso_results.mat', 'all_runs');
end
