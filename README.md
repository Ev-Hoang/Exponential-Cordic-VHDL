# Hyperbolic CORDIC – Digital Design (VHDL)

## Overview
This project implements a **Hyperbolic CORDIC (COordinate Rotation DIgital Computer)** using **VHDL**, designed for a **Digital Design** course.

The design follows a **Datapath + Controller (FSM)** architecture and uses **fixed-point arithmetic** to compute hyperbolic functions  `e`^`t`.

The main goal of this exercise is to practice:
- Fixed-point arithmetic in hardware
- FSM-based control design
- Modular VHDL design and simulation

---

## Algorithm Summary
CORDIC is an iterative algorithm that computes trigonometric and hyperbolic functions using only:
- Additions / subtractions
- Bit shifts
- Lookup tables (LUT)

In this project:
- **Hyperbolic CORDIC mode** is used
- Precomputed `atanh(2^-i)` values are stored in a LUT
- Fixed-point formats such as **Q8.24** are applied for accuracy

---

## How to Run

### 1. Compile
Compile all VHDL source files in your simulator (ModelSim / Questa / Vivado).

### 2. Simulate
Run the main testbench:
tb_cordic_top

---

## Notes
- The design supports repeated execution without manual reset
- Increasing the number of fractional bits improves numerical accuracy.
