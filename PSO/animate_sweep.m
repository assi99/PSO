function animate_sweep(mesh, features, best_params, sweep_param)
    param_names = {'scaleX','scaleY','scaleZ','pitch','yaw','shear'};
    sweep_ranges = {
        linspace(0.7, 1.3, 30),
        linspace(0.7, 1.3, 30),
        linspace(0.7, 1.3, 30),
        linspace(-30, 30, 30),
        linspace(-30, 30, 30),
        linspace(-0.5, 0.5, 30)
    };

    range = sweep_ranges{sweep_param};
    param_name = param_names{sweep_param};

    vols = zeros(size(range));
    areas = zeros(size(range));

    fig = figure(500); clf;
    set(fig, 'Name', ['Sweep Animation: ', param_name], 'NumberTitle', 'off');
    movegui(fig, 'center');

    for i = 1:length(range)
        p = best_params;
        p(sweep_param) = range(i);

        [A, ~, ~, V] = analyze_fitness_terms(p, mesh, features);
        vols(i) = V;
        areas(i) = A;

        % Update plot
        scatter(V, A, 150, 'filled');
        xlabel('Volume Proxy');
        ylabel('Frontal Area');
        title(sprintf('%s = %.3f', param_name, range(i)));
        xlim([min(vols)*0.9, max(vols)*1.1]);
        ylim([min(areas)*0.9, max(areas)*1.1]);
        grid on;
        drawnow;
    end
end
