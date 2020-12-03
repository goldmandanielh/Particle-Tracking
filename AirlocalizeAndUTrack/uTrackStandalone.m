function tracksFinal=uTrackStandalone(movieInfo, timeWindow, minTrackLen, maxSearchRadius)
%% general gap closing parameters
%
% Copyright (C) 2017, Danuser Lab - UTSouthwestern 
%
% This file is part of u-track.
% 
% u-track is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% u-track is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with u-track.  If not, see <http://www.gnu.org/licenses/>.
% 
if nargin<2
    timeWindow=4;
end
if nargin<3
    minTrackLen=2;
end
if nargin<4
    maxSearchRadius=5;
end

uTrackSetParameters;

%% tracking function call

[tracksFinal,kalmanInfoLink,errFlag] = trackCloseGapsKalmanSparse(movieInfo,...
    costMatrices,gapCloseParam,kalmanFunctions,probDim,saveResults,verbose);
end
% for i = 1 : 12
%     movieInfoTmp((i-1)*1200+1:i*1200) = movieInfo((i-1)*1200+1:i*1200);
%     saveResults.filename = ['tracks1All_' sprintf('%02i',i) '.mat'];
%     [tracksFinal,kalmanInfoLink,errFlag] = trackCloseGapsKalmanSparse(movieInfoTmp,...
%         costMatrices,gapCloseParam,kalmanFunctions,probDim,saveResults,verbose);
%     clear movieInfoTmp
% end

%% ~~~ the end ~~~