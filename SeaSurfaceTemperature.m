
classdef SeaSurfaceTemperature 



properties (SetAccess = private)

	DataDir = fullfile(fileparts(which(mfilename)),'data')
	DataURL = 'https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/YYYYMM/oisst-avhrr-v02r01.YYYYMMDD.nc'

end % private props

properties

	Latitude (1,1) = 42
	Longitude (1,1) = 290 % Boston harbour

	Date (1,1) datetime = datetime('01-Jan-2019')

end % props



methods 

	function self = SeaSurfaceTemperature()
		if exist(self.DataDir,'dir') == 0
			mkdir(self.DataDir)
		end
	end % constructor



	function data = fetch(self)


		% figure out the day we need
		[YYYYMM, YYYYMMDD] = SeaSurfaceTemperature.month2filename(self.Date);


			
		URL = strrep(self.DataURL,'YYYYMMDD',YYYYMMDD);
		URL = strrep(URL,'YYYYMM',YYYYMM);


		savename = fullfile(self.DataDir, YYYYMMDD);
		savename = [savename '.nc'];

		if exist(savename,'file') ~= 2
			disp('Downloading data from NOAA website...')
			try
				websave(savename,URL);
			catch err
				warning('Could not download data from NOAA website')
			end
		end


		% read data from this file
		lat = ncread(savename,'lat');
		lon = ncread(savename,'lon');
		sst = ncread(savename,'sst');

		[ActualLat,latidx] = min(abs(self.Latitude - lat));
		[ActualLon,lonidx] = min(abs(self.Longitude - lon));

		data.Temperature = sst(lonidx,latidx);
		data.Longitude = ActualLat;
		data.Latitide = ActualLon;
		data.Date = datetime(YYYYMMDD,'InputFormat','yyyyMMdd');
		data.SST = sst;


	end % fetch data


end % methods



methods (Static)


	function [YYYYMM, YYYYMMDD] = month2filename(M)

		download_this = datevec(M);
		YYYY = mat2str(download_this(1));
		MM = mat2str(download_this(2));
		DD = mat2str(download_this(3));
		if length(MM) == 1
			MM = ['0' MM];
		end

		if length(DD) == 1
			DD = ['0' DD];
		end

		YYYYMM = [YYYY MM];
		YYYYMMDD = [YYYY MM DD];
	end

end % static methods






end % classdef

