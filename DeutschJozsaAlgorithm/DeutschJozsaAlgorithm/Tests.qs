namespace Quantum.DeutschJozsaAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Testing;

    // ------------------------------------------------------
    operation ApplyOracle (qs : Qubit[], oracle : ((Qubit[], Qubit) => () : Adjoint)) : ()
    {
        body
        {
            let N = Length(qs);
            oracle(qs[0..N-2], qs[N-1]);
        }
        adjoint auto;
    }

    // ------------------------------------------------------
    operation AssertTwoOraclesAreEqual (nQubits : Range, 
            oracle1 : ((Qubit[], Qubit) => () : Adjoint), 
            oracle2 : ((Qubit[], Qubit) => () : Adjoint)) : ()
    {
        body
        {
            let sol = ApplyOracle(_, oracle1);
            let refSol = ApplyOracle(_, oracle2);
            for (i in nQubits) {
                AssertOperationsEqualReferenced(sol, refSol, i+1);
            }
        }
    }
    
    // ------------------------------------------------------
    operation T11_Oracle_Zero_Test () : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(1..10, Oracle_Zero, Oracle_Zero_Reference);
        }
    }

    // ------------------------------------------------------
    operation T12_Oracle_One_Test () : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(1..10, Oracle_One, Oracle_One_Reference);
        }
    }

    // ------------------------------------------------------
    operation T13_Oracle_Kth_Qubit_Test () : ()
    {
        body
        {
            let maxQ = 6;
            // loop over index of the qubit to be used
            for (k in 0..maxQ-1) {
                // number of qubits to try is from k+1 to 6
                AssertTwoOraclesAreEqual(k+1..maxQ, Oracle_Kth_Qubit(_, _, k), Oracle_Kth_Qubit_Reference(_, _, k));
            }
        }
    }

    // ------------------------------------------------------
    operation T14_Oracle_OddNumberOfOnes_Test () : ()
    {
        body
        {
            // cross-test: for 1 qubit it's the same as Kth_Qubit for k = 0
            AssertTwoOraclesAreEqual(1..1, Oracle_OddNumberOfOnes, Oracle_Kth_Qubit_Reference(_, _, 0));

            AssertTwoOraclesAreEqual(1..10, Oracle_OddNumberOfOnes, Oracle_OddNumberOfOnes_Reference);
        }
    }

    // ------------------------------------------------------
    operation AssertTwoOraclesWithBoolAreEqual (r : Bool[],  
            oracle1 : ((Qubit[], Qubit, Bool[]) => () : Adjoint), 
            oracle2 : ((Qubit[], Qubit, Bool[]) => () : Adjoint)) : ()
    {
        body
        {
            AssertTwoOraclesAreEqual(Length(r)..Length(r), oracle1(_, _, r), oracle2(_, _, r));
        }
    }

    operation T15_Oracle_ParityFunction_Test () : ()
    {
        body
        {
            // cross-tests
            // the mask for all true's corresponds to Oracle_OddNumberOfOnes
            mutable r = [true; true; true; true; true; true; true; true; true; true];
            let L = Length(r);
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ParityFunction(_, _, r[0..i-1]), Oracle_OddNumberOfOnes_Reference);
            }

            // the mask with all false's corresponds to Oracle_Zero
            for (i in 0..L-1) {
                set r[i] = false;
            }
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ParityFunction(_, _, r[0..i-1]), Oracle_Zero_Reference);
            }

            // the mask with only the K-th element set to true corresponds to Oracle_Kth_Qubit
            for (i in 0..L-1) {
                set r[i] = true;
                AssertTwoOraclesAreEqual(L..L, Oracle_ParityFunction(_, _, r), Oracle_Kth_Qubit_Reference(_, _, i));
                set r[i] = false;
            }

            set r = [true; false; true; false; true; false];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ParityFunction, Oracle_ParityFunction_Reference);

            set r = [true; false; false; true];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ParityFunction, Oracle_ParityFunction_Reference);

            set r = [false; false; true; true; true];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ParityFunction, Oracle_ParityFunction_Reference);
        }
    }

    operation T16_Oracle_ProductFunction_Test () : ()
    {
        body
        {
            // cross-tests
            // the mask for all true's corresponds to Oracle_OddNumberOfOnes
            mutable r = [true; true; true; true; true; true; true; true; true; true];
            let L = Length(r);
            for (i in 2..L) {
                AssertTwoOraclesAreEqual(i..i, Oracle_ProductFunction(_, _, r[0..i-1]), Oracle_OddNumberOfOnes_Reference);
            }

            set r = [true; false; true; false; true; false];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

            set r = [true; false; false; true];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);

            set r = [false; false; true; true; true];
            AssertTwoOraclesWithBoolAreEqual(r, Oracle_ProductFunction, Oracle_ProductFunction_Reference);
        }
    }

    operation T17_Oracle_HammingWithPrefix_Test () : ()
    {
        body
        {
            mutable prefix = [true];
            AssertTwoOraclesAreEqual(1..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

            set prefix = [true; false];
            AssertTwoOraclesAreEqual(2..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));

            set prefix = [false; false; false];
            AssertTwoOraclesAreEqual(3..10, Oracle_HammingWithPrefix(_, _, prefix), Oracle_HammingWithPrefix_Reference(_, _, prefix));
        }
    }

    // ------------------------------------------------------
    operation T21_BV_StatePrep_Test () : ()
    {
        body
        {
            for (N in 1..10) {
                using (qs = Qubit[N+1])
                {
                    // apply operation that needs to be tested
                    BV_StatePrep(qs[0..N-1], qs[N]);

                    // apply adjoint reference operation
                    (Adjoint BV_StatePrep_Reference)(qs[0..N-1], qs[N]);

                    // assert that all qubits end up in |0〉 state
                    AssertAllZero(qs);
                }
            }
        }
    }

    // ------------------------------------------------------
    operation AssertBVAlgorithmWorks (r : Bool[]) : ()
    {
        body
        {
            AssertBoolArrayEqual(BV_Algorithm(Length(r), Oracle_ParityFunction_Reference(_, _, r)), r, "Bernstein-Vazirani algorithm failed");
        }
    }

    operation T22_BV_Algorithm_Test () : ()
    {
        body
        {
            // test DJ the way we suggest the learner to test it:
            // apply the algorithm to reference oracles and check that the output is as expected
            AssertBVAlgorithmWorks([true; true]);
            AssertBVAlgorithmWorks([false; false; false]);
            AssertBVAlgorithmWorks([false; true; true; false]);
            AssertBVAlgorithmWorks([true; true; true; false; false]);
            AssertBVAlgorithmWorks([true; false; true; false; true; false]);
        }
    }

    // ------------------------------------------------------
    operation T31_DJ_Algorithm_Test () : ()
    {
        body
        {
            // test DJ the way we suggest the learner to test it:
            // apply the algorithm to reference oracles and check that the output is as expected
            AssertBoolEqual(DJ_Algorithm(4, Oracle_Zero_Reference), true, "f(x) = 0 not identified as constant");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_One_Reference), true, "f(x) = 1 not identified as constant");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_Kth_Qubit_Reference(_, _, 1)), false, "f(x) = x_k not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_OddNumberOfOnes_Reference), false, "f(x) = sum of x_i not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_ParityFunction_Reference(_, _, [true; false; true; true])), false, "f(x) = sum of r_i x_i not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_ProductFunction_Reference(_, _, [true; false; true; true])), false, "f(x) = sum of r_i x_i + (1 - r_i)(1 - x_i) not identified as balanced");
            AssertBoolEqual(DJ_Algorithm(4, Oracle_HammingWithPrefix_Reference(_, _, [false; true])), false, "f(x) = sum of x_i + 1 if prefix equals given not identified as balanced");
        }
    }

}