function [mesh, features] = load_stl_features(filename)
    s = stlread(filename);
    v = s.Points;
    f = s.ConnectivityList;

    mesh.faces = f;
    mesh.vertices = v;

    % Base centroid
    features.centroid = mean(v, 1);
    features.min_bound = min(v);
    features.max_bound = max(v);
end
