`timescale 1ns / 1ps

module decimal_fft_tb;

  reg clk;
  reg rst;

  // Input flags
  reg rin0_flag, rin1_flag, rin2_flag, rin3_flag, rin4_flag, rin5_flag, rin6_flag, rin7_flag;

  // Input data (real parts only)
  reg signed [15:0] rin0_whole, rin1_whole, rin2_whole, rin3_whole, rin4_whole, rin5_whole, rin6_whole, rin7_whole;
  reg        [15:0] rin0_frac,  rin1_frac,  rin2_frac,  rin3_frac,  rin4_frac,  rin5_frac,  rin6_frac,  rin7_frac;

  // Output wires
  wire signed [15:0] rout0_whole, rout1_whole, rout2_whole, rout3_whole, rout4_whole, rout5_whole, rout6_whole, rout7_whole;
  wire [15:0]        rout0_frac,  rout1_frac,  rout2_frac,  rout3_frac,  rout4_frac,  rout5_frac,  rout6_frac,  rout7_frac;

  wire signed [15:0] iout0_whole, iout1_whole, iout2_whole, iout3_whole, iout4_whole, iout5_whole, iout6_whole, iout7_whole;
  wire [15:0]        iout0_frac,  iout1_frac,  iout2_frac,  iout3_frac,  iout4_frac,  iout5_frac,  iout6_frac,  iout7_frac;

  wire rout0_flag, rout1_flag, rout2_flag, rout3_flag, rout4_flag, rout5_flag, rout6_flag, rout7_flag;
  wire iout0_flag, iout1_flag, iout2_flag, iout3_flag, iout4_flag, iout5_flag, iout6_flag, iout7_flag;



  decimal_fft dut (
    .clk(clk), .rst(rst),
    .rin0_flag(rin0_flag), .rin1_flag(rin1_flag), .rin2_flag(rin2_flag), .rin3_flag(rin3_flag),
    .rin4_flag(rin4_flag), .rin5_flag(rin5_flag), .rin6_flag(rin6_flag), .rin7_flag(rin7_flag),
    .rin0_whole(rin0_whole), .rin0_frac(rin0_frac), .rin1_whole(rin1_whole), .rin1_frac(rin1_frac),
    .rin2_whole(rin2_whole), .rin2_frac(rin2_frac), .rin3_whole(rin3_whole), .rin3_frac(rin3_frac),
    .rin4_whole(rin4_whole), .rin4_frac(rin4_frac), .rin5_whole(rin5_whole), .rin5_frac(rin5_frac),
    .rin6_whole(rin6_whole), .rin6_frac(rin6_frac), .rin7_whole(rin7_whole), .rin7_frac(rin7_frac),
    .rout0_whole(rout0_whole), .rout0_frac(rout0_frac), .rout1_whole(rout1_whole), .rout1_frac(rout1_frac),
    .rout2_whole(rout2_whole), .rout2_frac(rout2_frac), .rout3_whole(rout3_whole), .rout3_frac(rout3_frac),
    .rout4_whole(rout4_whole), .rout4_frac(rout4_frac), .rout5_whole(rout5_whole), .rout5_frac(rout5_frac),
    .rout6_whole(rout6_whole), .rout6_frac(rout6_frac), .rout7_whole(rout7_whole), .rout7_frac(rout7_frac),
    .iout0_whole(iout0_whole), .iout0_frac(iout0_frac), .iout1_whole(iout1_whole), .iout1_frac(iout1_frac),
    .iout2_whole(iout2_whole), .iout2_frac(iout2_frac), .iout3_whole(iout3_whole), .iout3_frac(iout3_frac),
    .iout4_whole(iout4_whole), .iout4_frac(iout4_frac), .iout5_whole(iout5_whole), .iout5_frac(iout5_frac),
    .iout6_whole(iout6_whole), .iout6_frac(iout6_frac), .iout7_whole(iout7_whole), .iout7_frac(iout7_frac),
    .rout0_flag(rout0_flag), .rout1_flag(rout1_flag), .rout2_flag(rout2_flag), .rout3_flag(rout3_flag),
    .rout4_flag(rout4_flag), .rout5_flag(rout5_flag), .rout6_flag(rout6_flag), .rout7_flag(rout7_flag),
    .iout0_flag(iout0_flag), .iout1_flag(iout1_flag), .iout2_flag(iout2_flag), .iout3_flag(iout3_flag),
    .iout4_flag(iout4_flag), .iout5_flag(iout5_flag), .iout6_flag(iout6_flag), .iout7_flag(iout7_flag)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("Starting decimal_fft_tb2 testbench");
    clk = 0;
    rst = 1;
    #10 rst = 0;

    // Sample inputs
    rin0_whole = 32; rin0_frac = 20; rin0_flag = 0;
    rin1_whole = 12; rin1_frac = 19; rin1_flag = 0;
    rin2_whole = 0; rin2_frac = 20; rin2_flag = 1;
    rin3_whole = 42; rin3_frac = 0; rin3_flag = 0;
    rin4_whole = -32; rin4_frac = 10; rin4_flag = 0;
    rin5_whole = 23; rin5_frac = 0; rin5_flag = 0;
    rin6_whole = 100; rin6_frac = 0; rin6_flag = 0;
    rin7_whole = 0; rin7_frac = 70; rin7_flag = 0;

    #100;

    $display("\n--- Final Output Rout/Iout ---");
if(rout0_whole==0 && rout0_flag==1)
    $write("R0 = -%d.%d, ",rout0_whole, rout0_frac);
else
    $write("R0 = %d.%d, ", rout0_whole, rout0_frac);
if(iout0_whole==0 && iout0_flag==1)
    $write("I0 = -%d.%d \n", iout0_whole, iout0_frac);
else
    $write("I0 = %d.%d \n", iout0_whole, iout0_frac);

if(rout1_whole==0 && rout1_flag==1)
    $write("R1 = -%d.%d, ", rout1_whole, rout1_frac);
else
    $write("R1 = %d.%d, ", rout1_whole, rout1_frac);
if(iout1_whole==0 && iout1_flag==1)
    $write("I1 = -%d.%d \n", iout1_whole, iout1_frac);
else
    $write("I1 = %d.%d \n", iout1_whole, iout1_frac);

if(rout2_whole==0 && rout2_flag==1)
    $write("R2 = -%d.%d, ", rout2_whole, rout2_frac);
else
    $write("R2 = %d.%d, ", rout2_whole, rout2_frac);
if(iout2_whole==0 && iout2_flag==1)
    $write("I2 = -%d.%d \n", iout2_whole, iout2_frac);
else
    $write("I2 = %d.%d \n", iout2_whole, iout2_frac);

if(rout3_whole==0 && rout3_flag==1)
    $write("R3 = -%d.%d, ", rout3_whole, rout3_frac);
else
    $write("R3 = %d.%d, ", rout3_whole, rout3_frac);
if(iout3_whole==0 && iout3_flag==1)
    $write("I3 = -%d.%d \n", iout3_whole, iout3_frac);
else
    $write("I3 = %d.%d \n", iout3_whole, iout3_frac);

if(rout4_whole==0 && rout4_flag==1)
    $write("R4 = -%d.%d, ", rout4_whole, rout4_frac);
else
    $write("R4 = %d.%d, ", rout4_whole, rout4_frac);
if(iout4_whole==0 && iout4_flag==1)
    $write("I4 = -%d.%d \n", iout4_whole, iout4_frac);
else
    $write("I4 = %d.%d \n", iout4_whole, iout4_frac);

if(rout5_whole==0 && rout5_flag==1)
    $write("R5 = -%d.%d, ", rout5_whole, rout5_frac);
else
    $write("R5 = %d.%d, ", rout5_whole, rout5_frac);
if(iout5_whole==0 && iout5_flag==1)
    $write("I5 = -%d.%d \n", iout5_whole, iout5_frac);
else
    $write("I5 = %d.%d \n", iout5_whole, iout5_frac);

if(rout6_whole==0 && rout6_flag==1)
    $write("R6 = -%d.%d, ", rout6_whole, rout6_frac);
else
    $write("R6 = %d.%d, ", rout6_whole, rout6_frac);
if(iout6_whole==0 && iout6_flag==1)
    $write("I6 = -%d.%d \n", iout6_whole, iout6_frac);
else
    $write("I6 = %d.%d \n", iout6_whole, iout6_frac);

if(rout7_whole==0 && rout7_flag==1)
    $write("R7 = -%d.%d, ", rout7_whole, rout7_frac);
else
    $write("R7 = %d.%d, ", rout7_whole, rout7_frac);
if(iout7_whole==0 && iout7_flag==1)
    $write("I7 = -%d.%d \n", iout7_whole, iout7_frac);
else
    $write("I7 = %d.%d \n", iout7_whole, iout7_frac);

    $display("\n--- Flags ---");
    $display("R flags: %b %b %b %b %b %b %b %b", rout0_flag, rout1_flag, rout2_flag, rout3_flag, rout4_flag, rout5_flag, rout6_flag, rout7_flag);
    $display("I flags: %b %b %b %b %b %b %b %b", iout0_flag, iout1_flag, iout2_flag, iout3_flag, iout4_flag, iout5_flag, iout6_flag, iout7_flag);

    $finish;
  end

endmodule
