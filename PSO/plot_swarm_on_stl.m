function plot_swarm_on_stl(mesh, features, particles)
    N = size(particles, 1);
    base_faces = mesh.faces;
    centroid = features.centroid;

    figure(777); clf;
    set(gcf, 'Name', 'Swarm Cloud Overlay on STL', 'NumberTitle', 'off');
    hold on; axis equal;
    title('Swarm Particle Geometries');
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view(3);

    for i = 1:N
        p = particles(i,:);
        v = mesh.vertices - centroid;

        % Transform particle geometry
        scale = p(1:3);
        pitch = deg2rad(p(4));
        yaw = deg2rad(p(5));
        shear = p(6);

        S = diag([scale, 1]);
        v = (S * [v, ones(size(v,1),1)]')';
        v(:,1) = v(:,1) + shear * v(:,3);

        Ry = [cos(pitch), 0, sin(pitch); 0 1 0; -sin(pitch), 0, cos(pitch)];
        v = (Ry * v(:,1:3)')';

        Rz = [cos(yaw), -sin(yaw), 0; sin(yaw), cos(yaw), 0; 0 0 1];
        v = (Rz * v')';

        % Plot transparent shell
        trisurf(base_faces, ...
            v(:,1)+centroid(1), v(:,2)+centroid(2), v(:,3)+centroid(3), ...
            'FaceAlpha', 0.05, 'EdgeColor', 'none', 'FaceColor', [0.2 0.4 1]);
    end

    hold off;
end
