int func(int n, int a, int b, int c, int d, int e, int f)
{
	int t = getchar()-'0'+a+b+c+d+e+f;
	if(n>1)
	{
		int x = func(n-1,a,b,c,d,e,f);
		int y = func(n-2,a,b,c,d,e,f);
		return x+y+t-1;
	}
	else{
		return t;
	}
}

int main()
{
	int n = getchar()-'0';
	int R0 = func(n,0,0,0,0,0,0);
	return R0;
}
