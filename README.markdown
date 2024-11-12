
# Pacman SystemVerilog FPGA Project
![PACMAN](https://imgur.com/a/ElWfQCZ.png)
This project is an implementation of the classic Pacman game on an **FPGA**, developed in **SystemVerilog** . The goal is to recreate Pacman gameplay with features such as character movement, wall detection, point collection, difficulty levels, and ghost management.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Project Architecture](#project-architecture)
- [Input and Output](#input-and-output)
- [Include files](#include-files)



## Introduction

This project replicates Pacman on an FPGA using VGA display. SystemVerilog modules manage interactions between the main character, ghosts, and the environment, including movement, collision detection, and point collection. The project is modular, with each component (Pacman, ghosts, map, etc.) separated into different blocks for clarity and flexibility.


## Features
- **VGA Display** :  VGA Interface with a resolution of 640x480.
- **Pacman Movement**: Position and direction control with centered display on a 10x10-pixel grid.
- **Intelligent Ghosts**: Ghosts follow Pacman, respecting allowed directions and avoiding unnecessary U-turns.
- **Wall and Object Detection**: Wall and collectible positions stored in RAM for easy access.
- **Score Counter**: Score display on a 7-segment display.
- **Level Management**: Gradually increasing difficulty, with dedicated logic for controlling ghost speed and behavior.
- **Reset to Initial State**: All game elements return to their initial positions when reset is triggered.
- **Sound** : Sound generation for different interactions in the game with a passif buzzer.

## Project Architecture

The project is organized into multiple modules for clarity and modularity.
Here a quick presentation of most importortant modules:

- `vga_controller`: Manages VGA display, handling `h_sync` and `v_sync` signals.
- `pacman_parameter`: Controls Pacman's parameters, including position, direction, and collision detection.
- `pacman_display`: Displays Pacman on the screen according to position and orientation.
- `ghost_ai`: Manages ghost intelligence, including direction calculations and distance control.
- `dots_display_logic`: Displays collectible points on the map and removes them as Pacman collects them.
- `game_master`: Controls game logic, difficulty levels, adjusting ghost parameters as needed.

![Architecture](https://imgur.com/a/WRWXUO2.png)

## Input and Output
 ### Input
 - `clk100MHz`: Main clock
 - `reset_n` : Reset actif low
 -  `up` : Up direction
 -  `down` : Down direction
 -  `left` : Left direction
 -  `right` : Right direction
 
 ### Output
 #### VGA Signals
 - `h_sync` : Horizontal synchronization signal 
 - `v_sync` : Vertical synchronization signal
 - `rgb` : rgb signal on 12 bits, 4 bits for each color
 #### 7 Segment Display
 -`SEG`: SEG signal on 7 bits to control each LED of the 7 display segment
 -`AN` : AN signal control what 7 segment display to turn on
 #### Wave for sound generation
 -`wave` : wave square signal to control a passif buzzer to have some sound
## Include Files


The `include_files` directory contains essential files for initializing images in memory. These files are used to load and configure images, making them accessible and manageable within the project.


