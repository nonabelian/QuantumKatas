namespace Quantum.Superposition
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Convert;
	open Microsoft.Quantum.Extensions.Math;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Superposition" quantum kata is a series of exercises designed 
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - basic single-qubit and multi-qubit gates,
    //  - superposition,
    //  - flow control and recursion in Q#.
    //
    // Each task is wrapped in one operation preceeded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    //
    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks. 

    // Task 1. Plus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |+〉 state on this qubit (|+〉 = (|0〉 + |1〉) / sqrt(2)).
    operation PlusState (qs : Qubit[]) : ()
    {
        body
        {
            // Hadamard gate H will convert |0〉 state to |+〉 state.
            // The first qubit of the array can be accesssed as qs[0].
            // Type H(qs[0]);
            // Then rebuild the project and rerun the tests - T01_PlusState_Test should now pass!

			H(qs[0]);
        }
    }

    // Task 2. Minus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |-〉 state on this qubit (|-〉 = (|0〉 - |1〉) / sqrt(2)).
    operation MinusState (qs : Qubit[]) : ()
    {
        body
        {
			X(qs[0]);
			H(qs[0]);
        }
    }

    // Task 3*. Unequal superposition
    // Inputs:
    //      1) a qubit in |0〉 state (stored in an array of length 1).
    //      2) angle alpha, in radians, represented as Double
    // Goal: create a cos(alpha) * |0〉 + sin(alpha) * |1〉 state on this qubit.
    operation UnequalSuperposition (qs : Qubit[], alpha : Double) : ()
    {
        body
        {
            // Hint: Experiment with rotation gates from Microsoft.Quantum.Primitive

            // ...
			Ry(2.0 * alpha, qs[0]);
        }
    }

    // Task 4. Bell pair
    // Input: two qubits in |00〉 state (stored in an array of length 2).
    // Goal: create a Bell pair (|00〉 + |11〉) / sqrt(2) on these qubits.
    operation BellPair (qs : Qubit[]) : ()
    {
        body
        {
            // ...
			H(qs[0]);
			CNOT(qs[0], qs[1]);
        }
    }

    // Task 5. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0〉 state.
    // Goal: create a GHZ state (|0...0〉 + |1...1〉) / sqrt(2) on these qubits.
    operation GHZ_State (qs : Qubit[]) : ()
    {
        body
        {
            // Hint: N can be found as Length(qs).
			H(qs[0]);
            for (i in 0..Length(qs)-2) {
				CNOT(qs[i], qs[i+1]);
			}
        }
    }

    // Task 6. Superposition of all basis vectors
    // Input: N qubits in |0...0〉 state.
    // Goal: create an equal superposition of all basis vectors from |0...0〉 to |1...1〉
    // (i.e. state (|0...0〉 + ... + |1...1〉) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition (qs : Qubit[]) : ()
    {
        body
        {
			ApplyToEach(H, qs);
        }
    }

    // Task 7. Superposition of |0...0〉 and given bitstring
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) bitstring represented as Bool[]
    // Goal: create an equal superposition of |0...0〉 and basis state given by the bitstring.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // You are guaranteed that the qubit array and the bitstring have the same length.
    // You are guaranteed that the first bit of the bitstring is true.
    // Example: for bitstring = [true; false] the qubit state required is (|00〉 + |10〉) / sqrt(2).
    operation ZeroAndBitstringSuperposition (qs : Qubit[], bits : Bool[]) : ()
    {
        body
        {
            // The following lines enforce the constraints on the input that you are given.
            // You don't need to modify them. Feel free to remove them, this won't cause your code to fail.
            AssertIntEqual(Length(bits), Length(qs), "Arrays should have the same length");
            AssertBoolEqual(bits[0], true, "First bit of the input bitstring should be set to true");

			H(qs[0]);

			for (i in 1..Length(bits)-1) {
				if (bits[i]) {
					CNOT(qs[0], qs[i]);
				}
			}
        }
    }

    // Task 8. Superposition of two bitstrings
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) two bitstring represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bitstrings.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // Example: for bitstrings [false; true; false] and [false; false; true] 
    // the qubit state required is (|010〉 + |001〉) / sqrt(2).
    // You are guaranteed that the both bitstrings have the same length as the qubit array,
    // and that the bitrstings will differ in at least one bit.
    operation TwoBitstringSuperposition (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : ()
    {
        body
        {
			mutable pos = 0;

			for (i in 0..Length(bits1)-1) {
				if (bits1[i] != bits2[i]) {
					set pos = i;
				}
			}

			H(qs[pos]);

			for (i in 0..Length(bits1)-1) {
				if (bits1[i]) {
					if (!bits1[pos]) {
						X(qs[pos]);
					}
					CNOT(qs[pos], qs[i]);
					if (!bits1[pos]) {
						X(qs[pos]);
					}
				}

				if (bits2[i]) {
					if (!bits2[pos]) {
						X(qs[pos]);
					}
					CNOT(qs[pos], qs[i]);
					if (!bits2[pos]) {
						X(qs[pos]);
					}
				}
			}
        }
    }

    // Task 9**. W state on 2^k qubits
    // Input: N = 2^k qubits in |0...0〉 state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000〉 + |0100〉 + |0010〉 + |0001〉) / 2.
    operation WState_PowerOfTwo (qs : Qubit[]) : ()
    {
        body
        {
			WState_Arbitrary(qs);
        }
    }

    // Task 10**. W state on arbitrary number of qubits
    // Input: N qubits in |0...0〉 state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100〉 + |010〉 + |001〉) / sqrt(3).
    operation WState_Arbitrary (qs : Qubit[]) : ()
    {
        body
        {
			let N = Length(qs);

			if (N == 1) {
				X(qs[0]);
			} else {
				mutable theta = ArcSin(1.0 / Sqrt(ToDouble(N)));
				Ry(2.0 * theta, qs[0]);

				for (i in 0..N-3) {
					set theta = ArcSin(1.0 / Sqrt(ToDouble(N-i-1)));
					MultiX(qs[0..i]);
					(Controlled Ry)(qs[0..i], (2.0 * theta, qs[i+1]));
					MultiX(qs[0..i]);
				}
				MultiX(qs[0..N-2]);
				(Controlled X)(qs[0..N-2], qs[N-1]);
				MultiX(qs[0..N-2]);
			}
        }
    }
}
