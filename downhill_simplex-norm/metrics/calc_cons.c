#include<stdio.h>
#include<math.h>
int main()
{
 FILE * fp;
 FILE * fp_cons;
 double fl_fs;
 double FLNT_m,FSNT_m;

 fp=fopen("ValueofConst","r");
 fscanf(fp,"%lf",&FLNT_m);
 fscanf(fp,"%lf",&FSNT_m);
 fl_fs=fabs(FLNT_m-FSNT_m);
 fp_cons=fopen("constraint","w");
 fprintf(fp_cons,"%lf\n",fl_fs);
 fprintf(fp_cons,"%lf\n",FLNT_m);
 fprintf(fp_cons,"%lf\n",FSNT_m);

 fclose(fp_cons);
 fclose(fp);
 return 0;
}
