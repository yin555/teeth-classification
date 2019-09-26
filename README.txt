This repository contains code used for the experiments discussed in the thesis project of Ying Yin for the Degree Master of Mathematical Sciences in the Graduate School of The Ohio State University. The thesis can be found at https://math.osu.edu/graduate/masters-theses (not yet available).

The goal of this project is to use optimal transport and persistence homology to quantify similarity between shapes via approximating lower bounds to the Gromov-Wasserstein distance and the Gromov-Hausdorff distance. To assess the performance of those lower bounds, we test the implementations against a data set containing surfaces of crowns of mammalian teeth, obtained from Boyer et al [1]. We use leave-one-out classification and probability of error (Pe) to measure the quality of classification.

Dependencies
----
This repository relies heavily on pre-existing packages for computations of optimal transport problem and persistence homology. The main packages needed can be found in the folder include/. However, compilations of these packages may require extra care, e.g. C++11 support. 

Usage
----
One can execute src/main.m to run an experiment. The default approach is optimal transport with a set of parameters. By tweaking the parameters, one can recreate the experiments discussed in the thesis. Pe and graphs will be saved in the folders out/pe and out/figures.


Reference
[1] Doug M. Boyer, Yaron Lipman, Elizabeth St. Clair, Jesus Puente, Biren A. Patel, Thomas Funkhouser, Jukka Jernvall, and Ingrid Daubechies. Algorithms to automat- ically quantify the geometric similarity of anatomical surfaces. Proceedings of the Na- tional Academy of Sciences, 108(45):18221–18226, 2011.