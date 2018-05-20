namespace Quantum.Superposition
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;

    // Task 1. Plus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |+〉 state on this qubit (|+〉 = (|0〉 + |1〉) / sqrt(2)).
    operation PlusState_Reference (qs : Qubit[]) : ()
    {
        body
        {
			H(qs[0]);
        }
        adjoint auto;
    }

    // Task 2. Minus state
    // Input: a qubit in |0〉 state (stored in an array of length 1).
    // Goal: create a |-〉 state on this qubit (|-〉 = (|0〉 - |1〉) / sqrt(2)).
    operation MinusState_Reference (qs : Qubit[]) : ()
    {
        body
        {
            X(qs[0]);
            H(qs[0]);
        }
        adjoint auto;
    }

    // Task 3. Unequal superposition
    // Inputs:
    //      1) a qubit in |0〉 state (stored in an array of length 1).
    //      2) angle alpha, in radians, represented as Double
    // Goal: create a cos(alpha) * |0〉 + sin(alpha) * |1〉 state on this qubit.
    operation UnequalSuperposition_Reference (qs : Qubit[], alpha : Double) : ()
    {
        body
        {
            // Hint: Experiment with rotation gates from Microsoft.Quantum.Primitive
            Ry(2.0 * alpha, qs[0]);
        }
        adjoint auto;
    }

    // Task 4. Bell pair
    // Input: two qubits in |00〉 state (stored in an array of length 2).
    // Goal: create a Bell pair (|00〉 + |11〉) / sqrt(2) on these qubits.
    operation BellPair_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
            CNOT(qs[0], qs[1]);
        }
        adjoint auto;
    }

    // Task 5. Greenberger–Horne–Zeilinger state
    // Input: N qubits in |0...0〉 state.
    // Goal: create a GHZ state (|0...0〉 + |1...1〉) / sqrt(2) on these qubits.
    operation GHZ_State_Reference (qs : Qubit[]) : ()
    {
        body
        {
            H(qs[0]);
            for (i in 1 .. Length(qs)-1) {
                CNOT(qs[0], qs[i]);
            }
        }
        adjoint auto;
    }

    // Task 6. Superposition of all basis vectors
    // Input: N qubits in |0...0〉 state.
    // Goal: create an equal superposition of all basis vectors from |0...0〉 to |1...1〉
    // (i.e. state (|0...0〉 + ... + |1...1〉) / sqrt(2^N) ).
    operation AllBasisVectorsSuperposition_Reference (qs : Qubit[]) : ()
    {
        body
        {
            for (i in 0 .. Length(qs)-1) {
                H(qs[i]);
            }
        }
        adjoint auto;
    }

    // Task 7. Superposition of |0...0〉 and given bitstring
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) bitstring represented as Bool[]
    // Goal: create an equal superposition of |0...0〉 and basis state given by the second bitstring.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // You are guaranteed that the qubit array and the bitstring have the same length.
    // You are guaranteed that the first bit of the bitstring is true.
    // Example: for bitstring = [True; False] the qubit state required is (|00〉 + |10〉) / sqrt(2).
    operation ZeroAndBitstringSuperposition_Reference (qs : Qubit[], bits : Bool[]) : ()
    {
        body
        {
            AssertIntEqual(Length(bits), Length(qs), "Arrays should have the same length");
            AssertBoolEqual(bits[0], true, "First bit of the input bitstring should be set to true");

            // Hadamard first qubit
            H(qs[0]);

            // iterate through the bitstring and CNOT to qubits corresponding to true bits
            for (i in 1..Length(qs)-1) {
                if (bits[i]) {
                    CNOT(qs[0], qs[i]);
                }
            }
        }
        adjoint auto;
    }

    // Task 8. Superposition of two bitstrings
    // Inputs:
    //      1) N qubits in |0...0〉 state
    //      2) two bitstring represented as Bool[]s
    // Goal: create an equal superposition of two basis states given by the bitstrings.
    // Bit values false and true correspond to |0〉 and |1〉 states.
    // Example: for bitstrings [false; true; false] and [false; false; true] 
    // the qubit state required is (|010〉 + |001〉) / sqrt(2).
    // You are guaranteed that the two bitstrings will be different.

    // helper function for TwoBitstringSuperposition_Reference
    function FindFirstDiff_Reference (bits1 : Bool[], bits2 : Bool[]) : Int
    {
        mutable firstDiff = -1;
        for (i in 0 .. Length(bits1)-1) {
            if (bits1[i] != bits2[i] && firstDiff == -1) {
                set firstDiff = i;
            }
        }
        return firstDiff;
    }

    operation TwoBitstringSuperposition_Reference (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : ()
    {
        body
        {
            // find the index of the first bit at which the bitstrings are different
            let firstDiff = FindFirstDiff_Reference(bits1, bits2);

            // Hadamard corresponding qubit to create superposition
            H(qs[firstDiff]);

            // iterate through the bitstrings again setting the final state of qubits
            for (i in 0 .. Length(qs)-1) {
                if (bits1[i] == bits2[i]) {
                    // if two bits are the same apply X or nothing
                    if (bits1[i]) {
                        X(qs[i]);
                    }
                } else {
                    // if two bits are different, set their difference using CNOT
                    if (i > firstDiff) {
                        CNOT(qs[firstDiff], qs[i]);
                        if (bits1[i] != bits1[firstDiff]) {
                            X(qs[i]);
                        }
                    }
                }
            }
        }
        adjoint auto;
    }

    // Task 9. W state on 2^k qubits
    // Input: N = 2^k qubits in |0...0〉 state.
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 4, W state is (|1000〉 + |0100〉 + |0010〉 + |0001〉) / 2.
    operation WState_PowerOfTwo_Reference (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base of recursion: |1〉
                X(qs[0]);
            } else {
                let K = N / 2;
                // create W state on the first K qubits
                WState_PowerOfTwo_Reference(qs[0..K-1]);

                // the next K qubits are in |0...0〉 state
                // allocate ancilla in |+〉 state
                using (anc = Qubit[1]) {
                    H(anc[0]);
                    for (i in 0..K-1) {
                        (Controlled SWAP)(anc, (qs[i], qs[i+K]));
                    }
                    for (i in K..N-1) {
                        CNOT(qs[i], anc[0]);
                    }
                }
            }
        }
		adjoint auto;
    }

    // Task 10. W state on arbitrary number of qubits
    // Input: N qubits in |0...0〉 state (N is not necessarily a power of 2).
    // Goal: create a W state (https://en.wikipedia.org/wiki/W_state) on these qubits.
    // W state is an equal superposition of all basis states on N qubits of Hamming weight 1.
    // Example: for N = 3, W state is (|100〉 + |010〉 + |001〉) / sqrt(3).

    // general solution based on rotations and recursive application of controlled generation routine
    operation WState_Arbitrary_Reference (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base case of recursion: |1〉
                X(qs[0]);
            } else {
                // |W_N> = |0〉|W_(N-1)> + |1〉|0...0〉
                // do a rotation on the first qubit to split it into |0〉 and |1〉 with proper weights
                // |0〉 -〉 sqrt((N-1)/N) |0〉 + 1/sqrt(N) |1〉
                let theta = ArcSin(1.0 / Sqrt(ToDouble(N)));
                Ry(2.0 * theta, qs[0]);
                // do a zero-controlled W-state generation for qubits 1..N-1
                X(qs[0]);
                (Controlled WState_Arbitrary_Reference)(qs[0..0], qs[1..N-1]);
                X(qs[0]);
            }
        }
        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // solution based on generation for 2^k and postselection using measurements
    operation WState_Arbitrary_Postselect (qs : Qubit[]) : ()
    {
        body
        {
            let N = Length(qs);
            if (N == 1) {
                // base case of recursion: |1〉
                X(qs[0]);
            } else {
                // find the smallest power of 2 which is greater than or equal to N
                // as a hack, we know we're not doing it on more than 64 qubits
                mutable P = 1;
                for (i in 1..6) {
                    if (P < N) {
                        set P = P * 2;
                    }
                }

                if (P == N) {
                    // prepare as a power of 2 (previous task)
                    WState_PowerOfTwo_Reference(qs);
                } else {
                    // allocate extra qubits
                    using (ans = Qubit[P-N]) {
                        let all_qubits = qs + ans;
                        repeat {
                            // prepare state W_P on original + ansilla qubits
                            WState_PowerOfTwo_Reference(all_qubits);

                            // measure ansilla qubits; if all of the results are Zero, we get the right state on main qubits
                            mutable allZeros = true;
                            for (i in 0..P-N-1) {
                                set allZeros = allZeros && IsResultZero(M(ans[i]));
                            }
                        } until allZeros
                        fixup {
                            ResetAll(ans);
                        }
                    }
                }
            }
        }
    }
}
