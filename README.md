# Preface

Here are my solutions to the "Quantum Katas" in Q#, including a dynamic programming solution to the arbitrary
W state construction.  Haven't done the Deutsch-Jozsa part yet.

Note: I don't recommend using Visual Studio Code.

# Introduction 

Quantum Katas are a series of self-paced tutorials aimed at teaching you elements of quantum computing and Q# programming at the same time.

Each tutorial covers one topic. Currently covered are:

* Superposition. Tasks which focus on preparing a certain state on one or multiple qubits.

Each tutorial is a separate project which includes:

* A sequence of tasks on the topic progressing from trivial to challenging. Each task requires you to fill in some code; the first task might require just one line, and the last one might require a sizeable fragment of code.
* A testing framework that sets up, runs and validates your solutions. Each task is covered by a unit test which initially fails; once the test passes, you can move on to the next task!
* Pointers to reference materials you might need to solve the tasks, both on quantum computing and on Q#.
* Reference solutions, for when all else fails.

# Getting Started

Prerequisites:

* A 64-bit installation of Windows, macOS or Linux.
* [.NET Core SDK 2.0](https://www.microsoft.com/net/learn/get-started) or later.
* You might want to install Microsoft Quantum Development Kit ([for Visual Studio 2017](https://marketplace.visualstudio.com/items?itemName=quantum.DevKit) or [for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=quantum.quantum-devkit-vscode)) to get a better experience working with Q# code. Follow [installation instructions](https://docs.microsoft.com/en-us/quantum/quantum-installconfig?view=qsharp-preview) to get Quantum Development Kit.

Clone this repository. Each tutorial is placed in its own directory and is a self-contained Q# project. Any tutorial-specific instructions and reference materials are listed in README.md of that tutorial.

To work on a tutorial, open the project in your preferred editor, build it and run the tests. Initially all tests will fail; do not panic! Open `Tutorial.qs` file and start filling in the code to complete the tasks. Each task is covered by a unit test; once you fill in correct code for a task, rebuild the project and re-run the tests, and the corresponding unit test will pass.

## Build and Test

### Visual Studio 2017

1. Open solution file (`.sln`) in the tutorial directory in Visual Studio. 
2. Build solution.
3. Open Test Explorer (found in `Test` > `Windows` menu) and select "Run All" to run all unit tests at once.
4. Work on the tasks in the `Tutorial.qs` file.
5. To test your code changes for a task, rebuild solution (build alone might not pick up changes in `.qs` files) and re-run all unit tests using "Run All" or the unit test which covers that task by right-clicking on that test and selecting "Run Selected Tests".

### Visual Studio Code

1. Open the repository in Visual Studio Code by either using *Open Folder...* from the Command Palette (Ctrl + Shift + P / ⌘ + Shift + P), or by running `code .` at the command line from within the repository.
   You may be prompted to install recommended extensions if you have not already done so above.
2. Press Ctrl + \` / ⌘ + \` to open the integrated terminal, and use `cd` to navigate to the tutorial of interest. For instance, run `cd Superposition` to work with the superposition tutorial.
3. Run `dotnet test` in the integrated terminal. This should automatically build the tutorial project and run all unit tests; initially, all unit tests should fail.
4. Work on the tasks in the `Tutorial.qs` file.
5. To test your code changes for a task, run `dotnet test` again.

For convienence, we also provide a `tasks.json` configuration for each tutorial that allows Visual Studio Code to run the build and test steps from the Command Palette.
Press Ctrl + Shfit + P / ⌘ + Shift + P to open the Palette and type "Run Build Task" or "Run Test Task," then press Enter.
You should be prompted for which tutorial you would like to run the build or test task for.


## Troubleshooting ##

### Visual Studio Code ###

- If the "Tasks: Run Test Task" item does not show up the Command Palette, or if no test tasks are configured, you may have opened a folder other than the tutorials repository folder.
  Press Ctrl + Shift + P / ⌘ + Shift + P to open the Palette and type "Open folder," press Enter, then navigate to the root folder for the tutorials repository.
  The root folder should contain a `.vscode` folder that Visual Studio Code uses to identify how to build and run projects.
- Running `dotnet test` from within the integrated terminal (Ctrl + \` / ⌘ + \`) may result in the following error:
  ```bash
  $ dotnet test
  MSBUILD : error MSB1003: Specify a project or solution file. The current working directory does not contain a project or solution file.
  ```
  This indicates that the `dotnet test` command was run from a folder other than a folder containing a tutorial solution.
  To solve this issue, use `cd` to navigate to the correct folder.
  For instance, if you have the tutorials repository open in Visual Studio Code:
  ```bash
  $ pwd
  .../QuantumKata
  $ cd Superposition
  $ dotnet test
  ```
