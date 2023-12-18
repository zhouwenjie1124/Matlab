# Minimizaton of Nonlinear Function

## Introduction

This project demonstrates how to use the Genetic Algorithm in MATLAB to find the minimum of the Rosenbrock Banana function.

## Rosenbrock Banana Function

The Rosenbrock Banana function is a two-dimensional function defined by the following equation:

f(x) = 100*(x2 - x1^2)^2 + (1 - x1)^2

where x = [x1, x2] is a two-dimensional variable.

## Toolbox

This toolbox is use MATLAB toolbox. 

## File Description

- `GeneticAlgorithm.m`: MATLAB code file that contains the process of using the Genetic Algorithm in MATLAB to find the minimum of the Rosenbrock Banana function.
- `graph.m`: MATLAB code file that includes the three-dimensional visualization of the Rosenbrock Banana function.
- `OptimizeLive.mlx`: MATLAB live code file that utilizes MATLAB's built-in Genetic Algorithm toolbox for quick parameter setup and result visualization.

## Configuration Parameters

You can adjust the Genetic Algorithm parameters to obtain better results. In the `GeneticAlgorithm.m` script, you can modify the following parameters:

- `PopulationSize`: The size of the population, default is 50.
- `Generations`: The number of generations, default is 100.
- `Display`: Display option, can be set to `'iter'` or `'final'`, default is `'final'`.

You can modify these parameters based on the complexity of your problem and the available computational resources to achieve better performance and results.

## Installation and Execution

1. Make sure you have MATLAB software installed. This project was developed and tested with MATLAB R2022b.
2. Clone or download the project code to your local machine.
3. Open MATLAB software and navigate to the project folder.
4. In the MATLAB command window, run the following command to start the Genetic Algorithm for finding the minimum:
    
    ```matlab
    >> GeneticAlgorithm
    ```
    
5. In the command window, you will see the iterative process of the Genetic Algorithm and the final result.

## Results

The Genetic Algorithm will attempt to find the minimum of the Rosenbrock Banana function. After running, you will see the obtained minimum value and the corresponding variable solution in the command window.

Please note that due to the stochastic nature of the Genetic Algorithm, each run may yield slightly different results. Additionally, to obtain more accurate results, you can try different parameter configurations or run multiple times to achieve stable results.