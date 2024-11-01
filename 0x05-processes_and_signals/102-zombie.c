#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

/**
 * main - Creates 5 zombie processes
 *
 * Return: Always 0 (Success)
 */

int infinite_while(void);

int main(void)
{
	int i;
	pid_t child_pid;

	i = 0;
	while (i < 5)
	{
		child_pid = fork();
		if (child_pid == 0)
		{
			exit(0);
		}
		else if (child_pid > 0)
		{
			printf("Zombie process created, PID: %d\n", child_pid);
		}
		i++;
	}
	infinite_while();

	return (0);
}

/**
 * infinite_while - Creates infinite loop
 *
 * Return: 0 on Success
 */

int infinite_while(void)
{
	while (1)
	{
		sleep(1);
	}
	return (0);
}
