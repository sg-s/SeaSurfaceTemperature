
classdef SeaSurfaceTemperature 



properties (SetAccess = private)

	DataDir = fullfile(fileparts(which(mfilename)),'data')
	DataURL = 'https://www1.ncdc.noaa.gov/pub/data/cmb/ersst/v5/netcdf/ersst.v5.YYYYMM.nc'

end % private props

properties

	latitute (1,1) = 42
	longitute (1,1) = 290 % Boston harbour

	after (1,1) datetime = datetime('01-Jan-2019')
	before (1,1) datetime = datetime - calmonths(1)

end % props



methods 

	function self = SeaSurfaceTemperature()

	end % constructor



	function data = fetch(self)


		% make a list of the months we need
		get_these_months = (self.after:calmonths(1):self.before)';


		% download all these months
		for i = 1:length(get_these_months)

			filename = SeaSurfaceTemperature.month2filename(get_these_months(i));
			
			URL = strrep(self.DataURL,'YYYYMM.nc',filename);
			savename = fullfile(self.DataDir, filename);


			if exist(savename,'file') ~= 2
				disp('Downloading data from NOAA website...')
				try
					websave(savename,URL);
				catch
					warning('Could not download data from NOAA website')
				end
			end

		end


		% make placeholders
		Latitide = NaN(length(get_these_months),1);
		Longitude  = Latitide;
		Date = get_these_months;
		Temperature = Latitide;


		for i = 1:length(get_these_months)
			filename = SeaSurfaceTemperature.month2filename(get_these_months(i));
			filename = fullfile(self.DataDir, filename);

			% read data from this file
			lat = ncread(filename,'lat');
			lon = ncread(filename,'lon');
			sst = ncread(filename,'sst');

			[~,latidx]=min(abs(lat-self.latitute));
			[~,lonidx]=min(abs(lon-self.longitute));

			Temperature(i) = sst(lonidx,latidx);
			Latitide(i) = lat(latidx);
			Longitude(i) = lon(lonidx);
		end

		% package
		data.Temperature = Temperature;
		data.Longitude = Longitude;
		data.Latitide = Latitide;
		data.Date = Date;


	end % fetch data


end % methods



methods (Static)


	function filename = month2filename(M)

		download_this = datevec(M);
		YYYY = mat2str(download_this(1));
		MM = mat2str(download_this(2));
		if length(MM) == 1
			MM = ['0' MM];
		end

		filename = [YYYY MM '.nc'];

	end

end % static methods






end % classdef

