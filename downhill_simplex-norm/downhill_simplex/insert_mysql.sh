#!/bin/csh

set experimenter = "'wuli'"
set NOTE = "'amip_2de'"


set inst_str = "$experimenter, "

#pre-processing: averaging Jan & Jul
set tune_model_path = "YOU/RUN/PATH/"
set climo_path="/YOUR/METRICS/PATH/"
set inst_str = "$inst_str `grep -w zmconv_c0_lnd $tune_model_path/atm_in  | cut -d = -f 2`,"
set inst_str = "$inst_str `grep -w zmconv_c0_ocn $tune_model_path/atm_in  | cut -d = -f 2`,"
set inst_str = "$inst_str `grep -w zmconv_tau    $tune_model_path/atm_in  | cut -d = -f 2`,"
set inst_str = "$inst_str `grep -w cldfrc_rhminh $tune_model_path/atm_in  | cut -d = -f 2`,"
set inst_str = "$inst_str `grep -w cldfrc_rhminl $tune_model_path//atm_in  | cut -d = -f 2`,"
set inst_str = "$inst_str `grep -w cldsed_ai     $tune_model_path/atm_in  | cut -d = -f 2`,"

foreach i (`cat $climo_path/rms_ratio`)
    set inst_str = "$inst_str `echo $i,`"
end

set inst_str = "$inst_str `cat $climo_path/mcpi`",

foreach j (`cat $climo_path/constraint`)
    set inst_str = "$inst_str `echo $j,`"
end
foreach i (`cat $climo_path/ValueofFLUT`)
    set inst_str = "$inst_str `echo $i,`"
end

set inst_str="$inst_str `cat ../weight`",

set inst_str="$inst_str `cat ../result`",

set inst_str = "$inst_str  $NOTE"
cat >! metrics_wuli.sql << EOF
USE tmp;
INSERT INTO table_name (experimenter, c0_lnd, c0_ocn, zmtau, rhminh, rhminl, ai,
LWCF,SWCF,PRECT, Q850,T850,MCPI,fl_fs,FLNT,FSNT,FLUT,FSNTOA,Weight,Result, NOTE) VALUES
($inst_str);
EOF

mysql -h "your ip" -u username -ppassword < metrics_wuli.sql

