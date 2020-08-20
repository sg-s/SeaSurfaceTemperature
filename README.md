# SeaSurfaceTemperature

Small MATLAB class to download sea surface temperatures from the NOAA website and present them in a sane manner.

## Usage


```matlab

% first, create the object
S = SeaSurfaceTemperature;


% specify where you want to get sea
% surface temperatures from. The database
% this uses is gridded at 5°, so don't 
% expect fine grained data
S.latitude = 10
S.longitude = 1.2 % will be rounded 

data = S.fetch();

```


