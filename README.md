# Simulation-Gear-Belt (V1.0.0)

![](./triangular_pulley.gif)

Please, let me know if you want a Python version.

Tested in:
* MATLAB 2020b - Windows 10 Education (2018).
* MATLAB 2020b - macOS Catalina Version 10.15.7.
* MATLAB 2021a - Ubuntu 18.04.5 LTS.

![](./project.png)

##  Introduction

This repository contains all scripts utilized in _Experiment in robotic self-repair_. We construct a mathematical model to simulate the interaction between the rotation of a non-standard timing pulley and its associated timing belt. In the article, we show an experiment where a 3D printer reaches self-repair under some conditions. Even when the capacity of a 3D printer to print some of its parts seems trivial, it becomes challenging when the printer presents some malfunctions.

## Functions description

* **h = circle(x,y,r,len)** creates the plot h with a circle of center in _(x,y)_, radius _r_, and LineWidth _len_.
* **[set_x, set_y, len, I] = convex_hull_set(picname)** loads the picture _picname_, and creates its convex hull. The sets _set_x_ and _set_y_ are the coordinates for each convex hull's vertex. The set _len_ contains the distances of each vertex to the center _(0,0)_. Finally, _I_ is the post-process image which now is in format _int8_.
* **[diff] = diff_image(img1,img2)** calculates the relative difference between figures _img1_ and _img2_, and provides it as an output in _diff_.
* **main_dudw_plots.m** loads a pulley's image, calculates its convex hull utilizing _convex_hull_set_, and plots the instant derivative du/dw. It also provides an animation that helps in visualizing how the derivative is calculated. **We recommend to check it out!**
* **[deriv_norm] = create_dudw(figure_name, Nw, dudw_norm)** loads pulley's image _figure_name_, and creates the vector _deriv_norm_ with the values of the derivative du/dw from 0 to 2pi with _Nw_ discretizations.
* **[] = convergence(pulley, model_3D, num_iter)** creates and saves the convergence plots from the inital pulley _pulley_, to the reference _model_3D_. _num_iter_ is the number of ploted iterations. 
* **output = printer(input,w0,dudw,ratio_pd)** simulates the process or printing the the 3D model _input_ with an ideal or non-ideal _x_-axis timing pulley. This timing pulley has an initial position _w0_, and its derivative regarding its contact with the belt is _dudw_. The value of _ratio_pd_ is related with the number of steps in the step motor, and _output_ contains a picture with the printer model.
* **[] = close_loop(pulley, model_3D, num_iter, substitution)** simulates the experimet described in the article. Depending on the value of the boolean variable _substitution_, it does:
1. False: This is the setup described in the article. The experiment starts utilizing the timing pulley _pulley_ in the _x_-axis, the reference _model_3D_ and attends to iterate _num_iter_ times. At each iteration after the first one, the utilized pulley in the _x_-axis is the output from the previous iteration.
2. True: This is an experimental setup that was still not explored. It is similar to the previous one, with the difference of substituting the _x_-axis pulley at each iteration and the reference (it is not fixed anymore) with the value of the previous output.
* **main.m** runs _close_loop_.

## Mathematics

The main mathematical contribution from the article's simulation section is the construction of du/dw from the timing pulley's convex hull. Essentially, the convex hull describes a set of triangles where all of them share the vertex _(0,0)_. Also, in the article, we mention the property: _At each time, one (and only one) vertex controls the belt's movement as a function of the pulley's rotation._ From the previous two properties, we find an exact expression for du/dw as it is described in **mathematical_model.pdf**.
Notice that the expression is exact in the described setup, where convex sets approximate timing pulleys.