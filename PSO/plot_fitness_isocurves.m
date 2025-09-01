function plot_fitness_isocurves(mesh, features)
    % Sweep 2D grid: scaleZ vs pitch
    scaleZ_vals = linspace(0.8, 1.2, 30);
    pitch_vals = linspace(-30, 30, 30);

    [SZ, PITCH] = meshgrid(scaleZ_vals, pitch_vals);
    fitness_map = zeros(size(SZ));
    volume_map = zeros(size(SZ));
    area_map = zeros(size(SZ));

    default_params = [1.0, 1.0, 1.0, 0, 0, 0]; % A neutral transform

    for i = 1:numel(SZ)
        p = default_params;
        p(3) = SZ(i);           % scaleZ
        p(4) = PITCH(i);        % pitch (degrees)
        [A, I, S, V] = analyze_fitness_terms(p, mesh, features);
        fitness_map(i) = 1.0*A + 0.05*I + 20*S + 0.1*V;
        volume_map(i) = V;
        area_map(i) = A;
    end

    fig = figure(400); clf;
    set(fig, 'Name', 'Fitness Isocurves', 'NumberTitle', 'off');
    movegui(fig, 'center');

    contourf(volume_map, area_map, fitness_map, 30, 'LineColor', 'none');
    xlabel('Volume Proxy'); ylabel('Frontal Area');
    title('Fitness Isocurves (ScaleZ vs Pitch)');
    colorbar;
    grid on;
end
