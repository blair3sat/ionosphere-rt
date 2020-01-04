# Raytracing implementation notes

This repository contains IONORT - IONOsphere Ray-Tracing, developed by INGV in Italy.

I've translated the code comments from Italian to English using the "Comment Translate" plugin on VSCode.

I've also included a list of the resources that I've used to understand the paper which is included in this repository.

## Resources

### Basic physics
https://en.wikipedia.org/wiki/Lagrangian_mechanics
https://en.wikipedia.org/wiki/Hamiltonian_mechanics
https://en.wikipedia.org/wiki/Canonical_coordinates
https://en.wikipedia.org/wiki/Generalized_coordinates 
https://en.wikipedia.org/wiki/Phase_space#Low_dimensions 


### Numerical solving methods
https://en.wikipedia.org/wiki/Linear_multistep_method
Numerical solutions to first order ODEs:
Runga Kutta - https://rosettacode.org/wiki/Runge-Kutta_method#Go
AB and AM methods - adaptive timestep to minimize error
Both have the concept of error, needs more indepth

https://lib.rs/crates/ode_solvers 
https://rotordynamics.wordpress.com/tag/runge-kutta-merson/ - RK Merson is a 5th order version of RK and runs much faster on Intel CPUs

Newton's notation for differentitation - dot symbolizes derivative wirh respect to time - https://en.wikipedia.org/wiki/Notation_for_differentiation#Newton's_notation 

julia has best ODE ecosystem

q are cartesian coordinates position and p is components of momentum
in the contex of paper:
r is coords
k is momenta

### Ionospheric models: 
Pezzopane et al 2011 - https://agupubs.onlinelibrary.wiley.com/doi/pdf/10.1029/2011RS004697 
Adaptive Ionospheric Profiler(AIP) model developed  by  Scotto  (2009) -  Available on SH

CHAPMAN vs DISCRETE_GRID use different iono models

WF means with magnetic fields, NF means no magnetic fields

## State of new version

Translated comments from `MATLAB/ionort.m` and `FORTRAN/IONORT_DISCRETE_GRID_WF/IONORT_DISCRETE_GRID_WF.FOR`. Since the fortran is written in punchcard mode, it most likely won't compile or work anymore. If you need this specific model, the binary for windows still exists and you can go back in the Git history.

Decided to write in Julia with Julia ODE ecosystem.