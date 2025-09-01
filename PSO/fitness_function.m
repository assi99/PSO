function score = fitness_function(params, mesh, features, verbose)
% FITNESS_FUNCTION Evaluates the aerodynamic fitness from the STL geometry
% params = [scaleX, scaleY, scaleZ, pitchDeg, yawDeg, shear]
% verbose = boolean flag for print

    if nargin < 4
        verbose = false;
    end

    try
        v = mesh.vertices - features.centroid;

        % Unpacking transformation parameters
        scale = params(1:3);
        pitch = deg2rad(params(4));
        yaw   = deg2rad(params(5));
        shear = params(6);

        % Applying scaling operation
        S = diag([scale, 1]);
        v = (S * [v, ones(size(v,1),1)]')';

        % Applying shear (X changes with Z)
        v(:,1) = v(:,1) + shear * v(:,3);

        % Applying pitch (Y rotation)
        Ry = [cos(pitch), 0, sin(pitch);
              0, 1, 0;
              -sin(pitch), 0, cos(pitch)];
        v = (Ry * v(:,1:3)')';

        % Applying yaw (Z rotation)
        Rz = [cos(yaw), -sin(yaw), 0;
              sin(yaw),  cos(yaw), 0;
              0,         0,        1];
        v = (Rz * v')';

        % Project into Y-Z plane for frontal area
        yz = v(:,2:3);
        k = convhull(yz);
        area = polyarea(yz(k,1), yz(k,2));

        % Moment of inertia (around Z axis)
        x = v(:,1); y = v(:,2);
        inertia = sum(x.^2 + y.^2);

        % Symmetry deviation (desired mean X ~ 0)
        symmetry = abs(mean(x));

        % Proxy volume
        volume_proxy = abs(scale(1) * scale(2) * scale(3));

        %Breakdown
        if verbose
            fprintf("Area: %.4f | Inertia: %.4f | Symmetry: %.4f | Volume: %.4f\n", ...
                area, inertia, symmetry, volume_proxy);
        end

        % Final score
        score = ...
            2.0 * area + ...
            0.5 * inertia + ...
            50.0 * symmetry + ...
            1.0 * volume_proxy;

        if isnan(score) || isinf(score)
            score = 1e6;
        end
    catch
        warning('fitness_function failed — fallback penalty returned.');
        score = 1e6;
    end
end
