# SeaSurfaceTemperature

![](https://user-images.githubusercontent.com/6005346/91308458-4bfcac00-e77d-11ea-9f0a-62359712e885.png)

Small MATLAB class to download sea surface temperatures from the NOAA website and present them in a sane manner.

## Usage


```matlab

% first, create the object
S = SeaSurfaceTemperature;


% specify where you want to get sea
% surface temperatures from. The database
% this uses is gridded at 5°, so don't 
% expect fine grained data
S.Latitude = 10
S.Longitude = 1.2 

data = S.fetch();

```

`data` also contains sea surface temperatures for the entire planet at that moment in time, allowing you to make pretty plots like the one shown above.



