volatile int *const outReg = (volatile int *)0xfffc;

int main() {
	int i = 2;
	int j;
	int isPrime = 0;

	while(1) {
		j = 2;
		isPrime = 1;
		while (j*j<=i) {
			if (i%j==0) {
				isPrime = 0;
				break;
			}
			j++;
		}

		if (isPrime) *outReg = i;

		i++;
	}
}
