#!/usr/bin/csh

set experimenter = "'wuli'"
set NOTE = "'tune_amip'"
#pre-processing: averaging Jan & Jul
set tune_model_path = "/YOUR/RUN/PATH/"

ncea -O $tune_model_path/wuli_cam5_amip_2de.cam.h1.200[2-5]-* wuli_cam5_amip_2de_2m.nc

ncwa -O -a lon,lat,time -w gw -v FLUT,FSNTOA,FLNT,FSNT wuli_cam5_amip_2de_2m.nc output.nc

set FLUT = "`ncdump output.nc | grep -i 'FLUT =' | cut -d = -f  2 | cut -d ';' -f 1`"
set FSNTOA = "`ncdump output.nc | grep -i 'FSNTOA =' | cut -d = -f  2 | cut -d ';' -f 1`"
set FLNT = "`ncdump output.nc | grep -i 'FLNT =' | cut -d = -f  2 | cut -d ';' -f 1`"
set FSNT = "`ncdump output.nc | grep -i 'FSNT =' | cut -d = -f  2 | cut -d ';' -f 1`"

cat >! ValueofFLUT <<EOF
$FLUT
$FSNTOA
EOF
cat >! ValueofConst << EOF
$FLNT
$FSNT
EOF

ncl calc_metrics.ncl 

./calc_cons

#./insert_mysql.sh
