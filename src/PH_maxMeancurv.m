function H0 = PH_maxMeancurv(paths,params,fname)

addpath(paths.in.javaplex)
load_javaplex;
    
import edu.stanford.math.plex4.*;
disp('imported javaplex')

[T,X,Y,Z] = read_ph_off([paths.in.data fname]);

I = load_fps(params,fname);

[dm,vfilt] = distance_matrix(params,I,T,X,Y,Z);

% build the simplicial complex
maxfilt_value = max(max(dm(:)),max(vfilt));
stream = api.Plex4.createExplicitSimplexStream(maxfilt_value+10);
efilt = @(k,l) max(max(vfilt(k),vfilt(l)),params.coef*dm(k,l));

for i = 1:length(I)
%     add each vertex to the simplicial complex
    stream.addVertex(i,vfilt(i));
    for j = i+1:length(I)
%         add edges in the triangulation to the simplicial complex
        if find_triangle(T,I(i),I(j))
            stream.addElement([i,j],efilt(i,j));
        end
    end
end
stream.finalizeStream();

% compute the persistence diagram in 0-dimension
persistence = api.Plex4.getModularSimplicialAlgorithm(1, 2);
intervals = persistence.computeIntervals(stream);
H0 = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, 0, 0);
inf_ind = isinf(H0(:,2));
% convert infinite bars to the diameter of the shapes
H0(inf_ind,2) = max(dm(:));

end

function bool = find_triangle(T,v1,v2)
% find if there is a triangle in the triangulation containing v1,v2 as two
% of the vertices
tri_indicator = sum(ismember(T,[v1,v2]),2);
bool = any(tri_indicator == 2);
end