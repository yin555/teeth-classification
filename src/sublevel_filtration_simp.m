function [infinite_barcodes,dgm_dict,intervals_dict] = sublevel_filtration_simp(T,f,dim,paths)
%compute persistence diagram of a given positive-valued function f using sublevel
%filtration
%@param: T a triangulation of the shape
%@param: f a funcion value at vertices
%@param: dim the dimension to which one want to compute

%adds javaplex path

wd = pwd;
addpath(paths.in.javaplex)
load_javaplex(paths);
import edu.stanford.math.plex4.*;

stream = api.Plex4.createExplicitSimplexStream(max(f)+10);

for face = T'
    edges_ind = nchoosek(1:length(face),2); %set index of edges
    for k = 1:size(edges_ind,1)
        vertexA = face(edges_ind(k,1));
        vertexB = face(edges_ind(k,2));
        stream.addVertex(vertexA,f(vertexA));
        stream.addVertex(vertexB,f(vertexB));
        stream.addElement([vertexA,vertexB],max(f(vertexA),f(vertexB)));
    end
    stream.addElement(face,max(f(face)));
end
if ~stream.validateVerbose()
    disp('Not a valid filtered simplicial complex')
    return
end
stream.finalizeStream();
persistence = api.Plex4.getModularSimplicialAlgorithm(dim, 2);
intervals = persistence.computeAnnotatedIntervals(stream);
infinite_barcodes = intervals.getInfiniteIntervals();
for curr_dim = 1:dim
    dgm = edu.stanford.math.plex4.homology.barcodes.BarcodeUtility.getEndpoints(intervals, curr_dim-1, 0);
    dgm_dict{curr_dim} = remove_trivial(dgm);
%     save output
    if nargout == 3
        intervals_dict{curr_dim} = intervals.getIntervalsAtDimension(curr_dim-1);
    end
end
clear stream
cd(wd)
end

function simp_dgm = remove_trivial(M)
    if isempty(M)
        simp_dgm = M;
        return;
    end
    try
        zero_persist = find(abs(M(:,1) - M(:,2)) < 1e-4);
    catch
        disp('not able to simplify dgm')
    end
    simp_dgm = M;
    simp_dgm(zero_persist,:) = [];
end

