function color_stl_by_metric(mesh, features, params, metric)
    v = mesh.vertices - features.centroid;
    scale = params(1:3);
    pitch = deg2rad(params(4));
    yaw   = deg2rad(params(5));
    shear = params(6);

    S = diag([scale, 1]);
    v = (S * [v, ones(size(v,1),1)]')';
    v(:,1) = v(:,1) + shear * v(:,3);
    v = (rotz(yaw) * roty(pitch) * v(:,1:3)')';

    x = v(:,1); y = v(:,2); z = v(:,3);

    switch metric
        case "area"
            c = abs(z); % YZ-projection (height)
        case "inertia"
            c = x.^2 + y.^2;
        case "symmetry"
            c = abs(x - mean(x));
        otherwise
            c = z; % fallback
    end

    figure; trisurf(mesh.faces, x, y, z, c, ...
        'EdgeColor', 'none'); axis equal; colorbar;
    title(['Color-coded STL by ', metric]);
end
