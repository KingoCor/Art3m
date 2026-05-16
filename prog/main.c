volatile unsigned int *const outReg = (volatile unsigned int *)0xfffc;

int main() {
	*outReg = 2;
	unsigned int i = 3;
	unsigned int j, isPrime;

	while(1) {
		j = 3;
		isPrime = 1;
		while (j*j<=i) {
			if (i%j==0) {
				isPrime = 0;
				break;
			}
			j++;
		}

		if (isPrime) *outReg = i;

		i+=2;
	}
}
