function plot_parameter_evolution(positionHistory)
    param_names = {'scaleX','scaleY','scaleZ','pitch','yaw','shear'};
    figure(600); clf;
    set(gcf, 'Name', 'Parameter Evolution', 'NumberTitle', 'off');
    movegui(gcf, 'center');

    for i = 1:6
        subplot(2,3,i);
        plot(positionHistory(:,i), 'LineWidth', 1.5);
        title(param_names{i}); grid on;
        xlabel('Iteration'); ylabel('Value');
    end
end
