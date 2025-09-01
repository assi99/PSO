clear; clc; close all;

% STL mesh and geometric features
[mesh, features] = load_stl_features('solution1STLfile.stl');

% Run PSO (with mutation + pareto tracking)
[best_transform, all_final_particles, positionHistory, pareto_log] = pso(features, mesh);

% Visualize final optimized geometry
visualize_result(mesh, best_transform);

% Volume vs. Area scatter of all final PSO geometries
plot_volume_area_tradeoff(mesh, features, all_final_particles);

% Ploting how volume and area evolve over time
plot_volume_area_over_time(positionHistory, mesh, features);

% Animate how one parameter affects performance
animate_sweep(mesh, features, best_transform, 4);  % 4 = pitch

% Overlayig all particle geometries on STL mesh
plot_swarm_on_stl(mesh, features, all_final_particles);

% Ploting parameter evolution
plot_parameter_evolution(positionHistory);

% Ploting fitness isocurves (scaleZ vs pitch)
plot_fitness_isocurves(mesh, features);

% Save data if needed
save('pso_results.mat', 'best_transform', 'positionHistory', 'pareto_log');

color_stl_by_metric(mesh, features, best_transform, "inertia"); 

run_multi_pso(mesh, features, 5);
