function [volume, surfaceArea] = stlVolume(v, f)
    volume = 0; surfaceArea = 0;
    for i = 1:size(f,1)
        p1 = v(f(i,1),:);
        p2 = v(f(i,2),:);
        p3 = v(f(i,3),:);
        triVol = dot(p1, cross(p2, p3))/6;
        volume = volume + triVol;
        surfaceArea = surfaceArea + norm(cross(p2-p1, p3-p1))/2;
    end
    volume = abs(volume);
end
