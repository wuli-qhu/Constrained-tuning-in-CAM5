#!/bin/bash 
paras="zmconv_c0_lnd:zmconv_c0_ocn:zmconv_tau:cldfrc_rhminh:cldfrc_rhminl:cldsed_ai"
model_base="/YOUR/RUN/PATH/"
#set namelist
#LID="`date +%y%m%d-%H%M%S`"
cd $model_base
paras_num=`echo $paras | awk -F ':' '{print NF}'`
for i in `seq 1 $paras_num`
do
	para=`echo $paras |cut -d : -f $i`
	var_line=`sed -n "$2p" paras.txt`
    para_val="$para=`echo $var_line |cut -d ' ' -f $i`"
    echo $para_val
    sed -i "/\<$para\>/c \\  $para_val" atm_in
done
#    mkdir $LID
#    mv capt_cam5_amip_2de.* $model_base/$LID
#	cp atm_in $model_base/$LID
#	mpiexec  -n 180  ./cesm.exe |& tee cesm.l
	sbatch -W run.sh
	#cd $model_base/downhill_simplex/metrics_new/
	#./get_metrics.sh
