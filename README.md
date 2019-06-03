# Constrained-tuning-in-CAM5

The source code of CAM5.3 are available from http://www.cesm.ucar.edu/models/cesm1.2/.

The codes in downhill_simplex-norm are divided into three folders: sa, downhill_simplex, metrics.

The sa folder contains the code of the single parameter perturbation (SPP) sampling, which provides good initial values for downhill simplex algorithm. More details can be found in Zhang et al (2015).'s paper "An automatic and effective parameter optimization method for model tuning".

The downhill_simplex folder contains downhill simplex algorithm and scripts for automatic parameter matching and model running. “downhill_simplex.c” is the main program, and its flow is as follows:

1. Obtaining physical parameters by downhill simplex optimization method;

2. Matching parameters to atm_in in CAM5 using “run-model.sh” script and submitting the AMIP experiment;

3. Using “get_metrics.sh” to obtain performance indicator of simulation;

4. “get_constraint” is used to obtain the constraint result and construct the final augmentation function;

5. Repeating the above process until the optimization end condition is reached.

The main script in the metrics folder is the “get_metrics.sh” mentioned above. It compares the model simulation results with the observations through the “calc_metrics.ncl” file to find the simulation performance indicator for each physical parameter combination. Then the radiation deviation of the model is calculated to determine whether it exceeds 1W/m2. If it exceeds, a large penalty is added to objective function.

obs.tar contains the observation data which is used to compute the metrics.

If you have any problem or question when using my code, please feel free contact me by email: wulitianyi@gmail.com
