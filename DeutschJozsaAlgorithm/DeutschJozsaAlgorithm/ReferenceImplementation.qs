namespace Quantum.DeutschJozsaAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //////////////////////////////////////////////////////////////////
    // Part I. Oracles
    //////////////////////////////////////////////////////////////////

    // Task 1.1. f(x) = 0
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_Zero_Reference (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Since f(x) = 0 for all values of x, |y ⊕ f(x)〉 = |y〉.
            // This means that the operation doesn't need to do any transformation to the inputs.
            // Build the project and run the tests to see that T01_Oracle_Zero_Test test passes.
        }
        adjoint auto;
    }

    // Task 1.2. f(x) = 1
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_One_Reference (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Since f(x) = 1 for all values of x, |y ⊕ f(x)〉 = |y ⊕ 1〉 = |NOT y〉.
            // This means that the operation needs to flip qubit y (i.e. transform |0〉 to |1〉 and vice versa).
            X(y);
        }
        adjoint auto;
    }

    // Task 1.3. f(x) = x_k (the value of k-th qubit)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) 0-based index of the qubit from input register (0 <= k < N)
    // Goal: transform state |x, y〉 into state |x, y ⊕ x_k〉 (⊕ is addition modulo 2).
    operation Oracle_Kth_Qubit_Reference (x : Qubit[], y : Qubit, k : Int) : ()
    {
        body
        {
            AssertBoolEqual(0 <= k && k < Length(x), true, "k should be between 0 and N-1, inclusive");
            CNOT(x[k], y);
        }
        adjoint auto;
    }

    // Task 1.4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_OddNumberOfOnes_Reference (x : Qubit[], y : Qubit) : ()
    {
        body
        {
            // Hint: f(x) can be represented as x_0 ⊕ x_1 ⊕ ... ⊕ x_(N-1)
            for (i in 0..Length(x)-1) {
                CNOT(x[i], y);
            }
            // alternative solution: ApplyToEachA(CNOT(_, y), x);
        }
        adjoint auto;
    }

    // Task 1.5. f(x) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for a given bit vector r (parity function)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length N represented as Bool[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    //
    // Note: the functions featured in tasks 1.1, 1.3 and 1.4 are special cases of parity function.
    operation Oracle_ParityFunction_Reference (x : Qubit[], y : Qubit, r : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            AssertIntEqual(Length(x), Length(r), "Arrays should have the same length");

            for (i in 0..Length(x)-1) {
                if (r[i]) {
                    CNOT(x[i], y);
                }
            }
        }
        adjoint auto;
    }

    // Task 1.6. f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for a given bit vector r
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length N represented as Bool[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_ProductFunction_Reference (x : Qubit[], y : Qubit, r : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            AssertIntEqual(Length(x), Length(r), "Arrays should have the same length");

            for (i in 0..Length(x)-1) {
                if (r[i]) {
                    CNOT(x[i], y);
                } else {
                    // do a 0-controlled NOT
                    X(x[i]);
                    CNOT(x[i], y);
                    X(x[i]);
                }
            }
        }
        adjoint auto;
    }

    // Task 1.7. f(x) = Σᵢ 𝑥ᵢ + (1 if prefix of x is equal to the given bit vector r, and 0 otherwise)
    // Inputs: 
    //      1) N qubits in arbitrary state |x〉 (input register)
    //      2) a qubit in arbitrary state |y〉 (output qubit)
    //      3) a bit vector of length P represented as Bool[] (1 <= P <= N)
    // Goal: transform state |x, y〉 into state |x, y ⊕ f(x)〉 (⊕ is addition modulo 2).
    operation Oracle_HammingWithPrefix_Reference (x : Qubit[], y : Qubit, prefix : Bool[]) : ()
    {
        body
        {
            // The following line enforces the constraint on the input arrays.
            // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
            let P = Length(prefix);
            AssertBoolEqual(1 <= P && P <= Length(x), true, "P should be between 1 and N, inclusive");

            // Hint: the first part of the function is the same as in task 1.4
            for (i in 0..Length(x)-1) {
                CNOT(x[i], y);
            }

            // add check for prefix as a multicontrolled NOT
            // true bits of r correspond to 1-controls, false bits - to 0-controls
            for (i in 0..P-1) {
                if (!prefix[i]) {
                    X(x[i]);
                }
            }
            (Controlled X)(x[0..P-1], y);
            // uncompute changes done to input register
            for (i in 0..P-1) {
                if (!prefix[i]) {
                    X(x[i]);
                }
            }
        }
        adjoint auto;
    }


    //////////////////////////////////////////////////////////////////
    // Part II. Bernstein-Vazirani Algorithm
    //////////////////////////////////////////////////////////////////

    // Task 2.1. State preparation for Bernstein-Vazirani algorithm
    // Inputs:
    //      1) N qubits in |0〉 state (query register)
    //      2) a qubit in |0〉 state (answer register)
    // Goal:
    //      1) create an equal superposition of all basis vectors from |0...0〉 to |1...1〉 on query register
    //         (i.e. state (|0...0〉 + ... + |1...1〉) / sqrt(2^N) )
    //      2) create |-〉 state (|-〉 = (|0〉 - |1〉) / sqrt(2)) on answer register
    operation BV_StatePrep_Reference (query : Qubit[], answer : Qubit) : ()
    {
        body
        {
            ApplyToEachA(H, query);
            X(answer);
            H(answer);
        }
        adjoint auto;
    }

    // Task 2.2. Bernstein-Vazirani algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x〉|y〉 -> |x〉|y ⊕ f(x)〉, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is a parity function
    // (can be represented as f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁)).
    // You have implemented the oracle implementing the parity function in task 1.5.
    // Output:
    //      A bit vector r reconstructed from the function
    operation BV_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => ())) : Bool[]
    {
        body
        {
            mutable r = new Bool[N];

            // allocate N+1 qubits
            using (qs = Qubit[N+1]) {
                // split allocated qubits into input register and answer register
                let x = qs[0..N-1];
                let y = qs[N];

                // prepare qubits in the right state
                BV_StatePrep_Reference(x, y);

                // apply oracle
                Uf(x, y);

                // apply Hadamard to each qubit of the input register
                ApplyToEach(H, x);

                // measure all qubits of the input register;
                // the result of each measurement is converted to a Bool
                for (i in 0..N-1) {
                    set r[i] = (M(x[i]) != Zero);
                }

                // before releasing the qubits make sure they are all in |0〉 state
                ResetAll(qs);
            }
            return r;
        }
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Deutsch-Jozsa Algorithm
    //////////////////////////////////////////////////////////////////

    // Task 3.1. Deutsch-Jozsa algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x〉|y〉 -> |x〉|y ⊕ f(x)〉, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is either 
    // constant (returns 0 on all inputs or 1 on all inputs) or 
    // balanced (returns 0 on exactly one half of the input domain and 1 on the other half).
    // Output:
    //      true if the function f is constant 
    //      false if the function f is balanced
    operation DJ_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => ())) : Bool
    {
        body
        {
            // Declare variable in which the result will be accumulated;
            // this variable has to be mutable to allow updating it.
            mutable isConstantFunction = true;

            // Hint: even though Deutsch-Jozsa algorithm operates on a wider class of functions
            // than Bernstein-Vazirani (i.e. functions which are not parity functions, such as f(x) = 1), 
            // it can be expressed as running Bernstein-Vazirani algorithm
            // and then post-processing the return value classically:
            // the function is constant if and only if all elements of the returned array are false

            let r = BV_Algorithm_Reference(N, Uf);
            for (i in 0..N-1) {
                set isConstantFunction = isConstantFunction && (!r[i]);
            }

            return isConstantFunction;
        }
    }
}
