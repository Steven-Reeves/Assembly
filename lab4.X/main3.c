// prototype
int var2(void);
int var3(int l, int m);

void main(void)
{
    int i = 10;
    int j = 20;

    func1 (1,5);
    //i = var2();
    j = i + 1;

}

int var2(void)
{
    int i = 10;
    int j = 20;

    //i = var3(1, 2) + j;
    return (i);
}

int func1(int ARG1, int ARG2)
{
    int LOC1 = 10;
    int LOC2 = 20;
    int LOC3 = 30;
    int x = func2(1,2,3,4,5);
        //k = i + j + l + m;

    return (LOC3);
}

int func2(int ARG1, int ARG2,int ARG3, int ARG4, int ARG5)
{
    int LOC1 = 10;
    int LOC2 = 20;
    int LOC3 = 30;

    return 42;
}