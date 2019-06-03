#include<stdio.h>
int main(int argc,char **argv)
{
	FILE *f_con,*f_r,*f_mcpi;
	int i;
	double w;
	double a;
	double w2;
	double mcpi,result;
	double cons=0;
//	f_w=fopen("../weight","r");
//	fscanf(f_w,"%lf",&w);
	
	f_con=fopen("../metrics_new/constraint","r");
	fscanf(f_con,"%lf",&a);
	cons=a;

	f_mcpi=fopen("../metrics_new/mcpi","r");
	fscanf(f_mcpi,"%lf",&mcpi);

        if(cons > 1.0)
	    w2=10000;
	else 
            w2=0;

	result=mcpi+w2*cons;
	
	f_r=fopen("../result","w");
	fprintf(f_r,"%lf",result);
	printf("///////////result finished//////////////");
	return 0;
}
