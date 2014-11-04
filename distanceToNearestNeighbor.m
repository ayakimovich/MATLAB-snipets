function nearesetEuclidianDistances = distanceToNearestNeighbor(x1vect,y1vect, x2vect, y2vect)
    % finds a nearest neighbor and returns the eucledian distance to it
    %
    % INPUT: x1vect and y1vect - coordinates of the point of interest,
    % x2vect and y2vect - vectors containing the points to search coordinates
    % OUTPUT: eucledianDistance - vector containing ditances in float point
    % precision
    lengthx1 = length(x1vect);
    lengthy1 = length(y1vect);
    lengthx2 = length(x2vect);
    lengthy2 = length(y2vect);
    
    nearesetEuclidianDistances = zeros(lengthx1,1);
    if lengthx1 == lengthy1 &&  lengthx2 == lengthy2
        
        for i = 1:lengthx1
                euclidianDistances =  sqrt((repmat(x1vect(i), lengthx2, 1) - x2vect).^2 ... 
                                           + (repmat(y1vect(i), lengthy2, 1) - y2vect).^2);
               
                 nearesetEuclidianDistances(i) = min(euclidianDistances);
                
        end
       
    else
        error('coordinates in x1vect, y1vect and x2vect, y2vect vectors must have equal length');
    end
end