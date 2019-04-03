#include<stdio.h>
#include<stdlib.h>
int main(int argc,char **argv)
{
	int NMAX;//number of samplings
	FILE *init,*sampling;
	int i,j,k;
	int num;
	double *a;
	double *b;
	double *c;
	double *interval;
	double *def;
	NMAX=atoi(argv[1]);
	printf("NMAX is %d\n",NMAX);
	init=fopen("initpara","r");
	sampling=fopen("spp_data","w");
	fscanf(init,"%d",&num);	
	a=(double*)malloc(num*sizeof(double));
	b=(double*)malloc(num*sizeof(double));
	c=(double*)malloc(num*sizeof(double));
	def=(double*)malloc(num*sizeof(double));
	interval=(double*)malloc(num*sizeof(double));
	for(i=0;i<num;i++)
	{
		fscanf(init,"%lf %lf %lf",&a[i],&b[i],&def[i]);
		printf("init i is %d,para range from %lf to %lf\n",i,a[i],b[i]);
		c[i]=b[i]-a[i];
		interval[i]=c[i]/(NMAX-1);
	}
	//////insert default value/////
	for(i=0;i<num;i++)
	{
		fprintf(sampling,"%lf",def[i]);
		fprintf(sampling," ");
	}
	fprintf(sampling,"\n");


	for(k=0;k<num;k++)
	{
		for(i=0;i<NMAX;i++)
		{
			for(j=0;j<num;j++)
			{
				if(j==k)
				{

					fprintf(sampling,"%lf",a[j]+interval[k]*i);

				}

				else
					fprintf(sampling,"%lf",def[j]);
				fprintf(sampling," ");

			}
			fprintf(sampling,"\n");

		}

	}



	return 0;

}
