load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/ut_string.ncl"

begin
	var_names = (/"LWCF", "SWCF", "PRECT", "Q850", "T850"/)
	;obs_path = "climo/obs/CAPT/"
	obs_path = "/YOUR/OBS/PATH/"
	climo_path = "/YOUR/CLIMO/PATH/"
	mcpi_path = "/YOUR/METRICS/PATH/"
	
	num_vars = dimsizes(var_names)
	var_rms = new((/num_vars/), float)
	var_rms_str = new((/num_vars/), string)
	var_rms@_FillValue = 1.0e33
	var_rms = var_rms@_FillValue

	deg2rad = atan(1.0)/45.0

	do k = 0, num_vars - 1
		print(var_names(k))
		;obs_file   = obs_path  + "/" + var_names(k) +"_Jul.nc"
		;obs_file   = obs_path  + var_names(k)  + "/" + var_names(k) +"_Jul_mean.nc"
		obs_file   = obs_path    + "/" + var_names(k) +".nc"
		model_file = "wuli_cam5_amip_2de_2m.nc"

		fp_obs     = addfile(obs_file, "r")
		var_obs = fp_obs->$var_names(k)$
   		lat_obs = fp_obs->lat
    	lon_obs = fp_obs->lon
;    	var_obs!0 = "lat"
;    	var_obs!1 = "lon"
    	var_obs&lat = lat_obs
    	var_obs&lon = lon_obs
		lat_obs_wei = lat_obs * deg2rad
		lon_dim = dimsizes(lon_obs)
		lat_dim = dimsizes(lat_obs)	
   		wgt = new((/lat_dim, lon_dim/), float)
    	do i = 0, lat_dim-1
         	wgt(i,:) = doubletofloat(cos(lat_obs_wei(i)))
    	end do

		fp_model   = addfile(model_file, "r")
		var_model  = fp_model ->$var_names(k)$(0,:,:)
		lon_model  = fp_model->lon
    	lat_model  = fp_model->lat
;        lev_model  = fp_model->lev
;        hyam_model = fp_model->hyam
;        hybm_model = fp_model->hybm
;        P0mb = fp_model->P0*0.01

;		var_model_remap = area_conserve_remap_Wrap(lon_model,lat_model,var_model,lon_obs,lat_obs,False)
		if (var_names(k) .eq. "PRECT")
			var_model = var_model * 1000.0 * 86400.0
		end if
        if (var_names(k) .eq. "Q850")
            var_model = var_model * 1000.0
        end if
 
		var_rms(k) = sum(wgt*(var_obs - var_model)^2)
		print("var_k")
		var_rms_str(k) = sprintf("%10.16f", var_rms(k))		

		delete(var_obs)
		delete(lat_obs)
		delete(lon_obs)
		delete(lat_obs_wei)
		delete(wgt)	
		delete(var_model)	
	end do
		
	print(var_rms_str)

	control_rms = asciiread(climo_path+"control_rms_1m", -1, "float")
	rms_ratio = var_rms / control_rms
	asciiwrite(mcpi_path+"rms_ratio", rms_ratio)
	mcpi = dim_avg_n(rms_ratio,0)
	print(mcpi)
	asciiwrite(mcpi_path+"mcpi", mcpi)
    print("/////////////////write mcpi success //////////////////")
end
