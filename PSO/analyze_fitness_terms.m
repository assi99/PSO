function [area, inertia, symmetry, vol] = analyze_fitness_terms(transform, mesh, features)
    v = mesh.vertices - features.centroid;
    scale = transform(1:3);
    pitch = deg2rad(transform(4));
    yaw   = deg2rad(transform(5));
    shear = transform(6);

    % Apply transformations
    S = diag([scale, 1]);
    v = (S * [v, ones(size(v,1),1)]')';
    v(:,1) = v(:,1) + shear * v(:,3);
    v = (rotz(yaw) * roty(pitch) * v(:,1:3)')';

    % Project to YZ-plane for area calc
    yz = v(:,2:3);
    k = convhull(yz); 
    area = polyarea(yz(k,1), yz(k,2));

    % Volume proxy
    vol = abs(scale(1) * scale(2) * scale(3));

    % Inertia (approximated as trace of covariance)
    C = cov(v); 
    inertia = trace(C);

    % Symmetry (compare mirrored halves)
    y = v(:,2); 
    left  = v(y > 0, :); 
    right = v(y < 0, :); 
    right(:,2) = -right(:,2);
    min_count = min(size(left,1), size(right,1));
    d = vecnorm(left(1:min_count,:) - right(1:min_count,:), 2, 2);
    symmetry = mean(d);
end
