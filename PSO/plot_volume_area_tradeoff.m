function plot_volume_area_tradeoff(mesh, features, all_positions)
    N = size(all_positions, 1);
    volumes = zeros(N,1);
    areas = zeros(N,1);

    for i = 1:N
        [area, ~, ~, vol] = analyze_fitness_terms(all_positions(i,:), mesh, features);
        volumes(i) = vol;
        areas(i) = area;
    end

    fig = figure(200); clf;
    set(fig, 'Name', 'Volume vs Frontal Area (All PSO Particles)', 'NumberTitle', 'off');
    movegui(fig, 'center');

    scatter(volumes, areas, 80, 'filled');
    xlabel('Volume Proxy'); ylabel('Frontal Area');
    title('All PSO Particles at Final Iteration');
    grid on;
end
