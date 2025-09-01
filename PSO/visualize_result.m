function visualize_result(mesh, params)
    % Applying the best transformation for visualizing the geometry
    v = mesh.vertices;
    scale = params(1:3);
    pitch = deg2rad(params(4));
    yaw   = deg2rad(params(5));
    shear = params(6);

    % Center
    centroid = mean(v,1);
    v = v - centroid;

    %  Transformations
    S = diag([scale, 1]);
    v = (S * [v, ones(size(v,1),1)]')';

    v(:,1) = v(:,1) + shear * v(:,3); % Shear

    Ry = [cos(pitch), 0, sin(pitch); 0 1 0; -sin(pitch), 0, cos(pitch)];
    v = (Ry * v(:,1:3)')';

    Rz = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0 0 1];
    v = (Rz * v')';

    % Ploting
    fig = figure(1); clf;
    set(fig, 'Name', 'Transformed STL Geometry', 'NumberTitle', 'off');
    movegui(fig, 'center');

    trisurf(mesh.faces, v(:,1)+centroid(1), v(:,2)+centroid(2), v(:,3)+centroid(3), ...
        'FaceAlpha', 0.3, 'EdgeColor', 'none');
    axis equal;
    title('Transformed Drone Geometry');
end
