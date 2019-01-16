
// unbounded overtaking for p0
ltl unb1 {[]((y[0]==1 ) -> <>(y[0]==0))}
// unbounded overtaking for p1
ltl unb2  {[]((y[1]==1 ) -> <>(y[1]==0))}
// occupy p0's critical section infinitely often
ltl inf1 {[]<>(y[0]==1)}
// occupy p1's critical section infinitely often
ltl inf2 {[]<>(y[1]==1)}

bit s = 1;
bit y[2];

/first process
active proctype p0(){
	do /* loop forever */
	:: true->/* non critical section */
		atomic{
			y[0] = 1;
			s = 0;
		}
		y[1] == 0 || s!=0
		/*critical section*/
		y[0]=0;
	od
}

//second process
active proctype p1(){
	do
	:: true->/* non critical section */
		atomic{
			y[1] = 1;
			s = 1;
		}
		y[0] == 0 || s!=1
		/*critical section*/
		y[1]=0;
	od
}


init {
	atomic{

		run p0();
		run p1();
	}
}
// Mutual exclusion claim.
never {
T0_init:
	do
	:: (! (((y[0]==1 && (y[1]==0 || s!=0)) && (y[1]==1 && (y[0]==0 || s!=1))))) -> goto T0_init
	:: else -> skip;
	od;
}
