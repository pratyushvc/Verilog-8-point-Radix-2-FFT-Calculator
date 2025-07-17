# 8-Point Radix-2 FFT with Decimal Handling in Verilog

This project implements an 8-point Radix-2 FFT (Fast Fourier Transform) module in Verilog with support for fixed-point decimal arithmetic. It is designed for digital signal processing applications where hardware-friendly computation of FFT is essential, such as in FPGAs or custom DSP processors.

# Features

- 8-point Radix-2 Decimation-in-Time FFT
- Implemented the Cooley-Tukey Algorithm
- Special decimal support to increase the precision
- Designed flag-based input encoding to special fixed-point decimal values (e.g., -0.23, -0.34, -0.7) and automatic propogation of such flags till the output side to display similiar values.
- Implemented a testbench

# Motivation

Traditional FFT implementations in Verilog often ignore decimal precision or use floating-point units, which are expensive in terms of hardware resources. This project avoids floating-point units and instead simulates decimal behavior using a fixed-point format with separate integer and fractional handling.

This makes the design more practical for hardware accelerators in low-power embedded systems and edge devices.

# Files

**decimal_fft.v**- 
- The flags rin0_flag, rin1_flag similarly until rin7_flag represent the input flags which indicate whether are negative decimal values like -0.2,-0.86,etc. (have to be enabled to 1)
- rin0_whole, rin1_whole uptil rin7_whole indicate the (signed) 16 bit real whole number inputs
- rin0_frac, rin1_frac uptil rin7_frac indicate the 16 bit real fractional number inputs
- rout0_whole, rout1_whole uptil rout7_whole indicate the (signed) 16 bit real whole number outputs.
- rout0_frac, rout1_frac uptil rout7_frac indicate the 16 bit real fractional number outputs.
- iout0_whole, iout1_whole uptil iout7_whole indicate the (signed) 16 bit imaginary whole number outputs.
- iout0_frac, iout1_frac uptil iout7_frac indicate the 16 bit imaginary whole number outputs.
- rout0_flag, rout1_flag uptil rout7_flag carry the same functionality for real outputs
- iout0_flag, iout1_flag uptil iout7_flag carry the same functionality for real outputs

**decimal_fft_tb.v**- Testbench (included custom input values of {32.20, 12.19, -0.20, 42.00, -32.10, 23.00, 100, 0.7} and singalled rin2_flag =1 to indicate -0.2) 

# Improvements to be made
- Shift to array based inputs
- Scale up to higher point FFT calculation
- Optimise printing of output in testbench by comparing with output flags

