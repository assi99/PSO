clear; clc; close all;

% Load STL mesh and geometric features
[mesh, features] = load_stl_features('solution1STLfile.stl');

% Run Particle Swarm Optimization (with mutation + Pareto tracking)
[best_transform, all_final_particles, positionHistory, pareto_log] = pso(features, mesh);

% Visualize the final optimized geometry
visualize_result(mesh, best_transform);

% Volume vs. Area scatter of all final particle geometries
plot_volume_area_tradeoff(mesh, features, all_final_particles);

% Plot how volume and area evolved over time
plot_volume_area_over_time(positionHistory, mesh, features);

% Animate how one parameter affects performance
animate_sweep(mesh, features, best_transform, 4);  % 4 = pitch

% Overlay all particle geometries on STL mesh
plot_swarm_on_stl(mesh, features, all_final_particles);

% Plot parameter evolution
plot_parameter_evolution(positionHistory);

% Plot fitness isocurves (scaleZ vs pitch)
plot_fitness_isocurves(mesh, features);

% Save data if needed
save('pso_results.mat', 'best_transform', 'positionHistory', 'pareto_log');

color_stl_by_metric(mesh, features, best_transform, "inertia"); % or "area", "symmetry"

run_multi_pso(mesh, features, 5);
