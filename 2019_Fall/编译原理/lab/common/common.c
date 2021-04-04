#include "common.h"

int getAllTestcase(char filename[][256])
{
	/// \todo student should fill this function
	
	struct dirent* dir=NULL;
	DIR *p;
	int i=0;
	p=opendir("./testcase/");
	while(dir=readdir(p))
	{
		if(dir->d_name[0]=='.') 
		    continue;
		strcpy(filename[i],dir->d_name);
		i++;	
	}
	return i;
}

