function plot_volume_area_over_time(history, mesh, features)
    N = size(history, 1);
    vols = zeros(N,1);
    areas = zeros(N,1);

    for i = 1:N
        [area, ~, ~, vol] = analyze_fitness_terms(history(i,:), mesh, features);
        areas(i) = area;
        vols(i) = vol;
    end

    fig = figure(300); clf;
    set(fig, 'Name', 'Volume-Area Evolution', 'NumberTitle', 'off');
    movegui(fig, 'center');

    plot(vols, areas, '-o', 'LineWidth', 2);
    xlabel('Volume Proxy');
    ylabel('Frontal Area');
    title('Evolution of Volume vs Area Over Iterations');
    grid on;
end
