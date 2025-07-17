module decimal_fft (
    input  wire        clk,
    input  wire        rst,
// Input flags for rin0 to rin7
input wire rin0_flag,

input wire rin1_flag,

input wire rin2_flag,

input wire rin3_flag,

input wire rin4_flag,

input wire rin5_flag,
input wire rin6_flag,

input wire rin7_flag,


// Output flags for rout0 to rout7(Real)
output reg rout0_flag,

output reg rout1_flag,

output reg rout2_flag,

output reg rout3_flag,
output reg rout4_flag,

output reg rout5_flag,

output reg rout6_flag,

output reg rout7_flag,

//Output flags fo iout0 to iout7(Imag)
output reg iout0_flag,

output reg iout1_flag,

output reg iout2_flag,

output reg iout3_flag,

output reg iout4_flag,

output reg iout5_flag,

output reg iout6_flag,

output reg iout7_flag,

    
    input  wire signed   [15:0] rin0_whole, 
    input  wire         [15:0] rin0_frac, 

    input  wire signed   [15:0] rin1_whole, 
    input  wire         [15:0] rin1_frac,
    input  wire signed   [15:0] rin2_whole, 
    input  wire         [15:0] rin2_frac, 
    input  wire signed   [15:0] rin3_whole, 
    input  wire         [15:0] rin3_frac,
    input  wire signed   [15:0] rin4_whole, 
    input  wire         [15:0] rin4_frac,
    input  wire signed   [15:0] rin5_whole, 
    input  wire         [15:0] rin5_frac, 
    input  wire signed   [15:0] rin6_whole, 
    input  wire         [15:0] rin6_frac, 
    input  wire signed   [15:0] rin7_whole, 
    input  wire         [15:0] rin7_frac, 

    output reg signed   [15:0] rout0_whole, 
    output reg         [15:0] rout0_frac, 
    output reg signed   [15:0] iout0_whole, 
    output reg         [15:0] iout0_frac,

    output reg signed   [15:0] rout1_whole, 
    output reg         [15:0] rout1_frac, 
    output reg signed   [15:0] iout1_whole, 
    output reg         [15:0] iout1_frac,

    output reg signed   [15:0] rout2_whole, 
    output reg         [15:0] rout2_frac, 
    output reg signed   [15:0] iout2_whole, 
    output reg         [15:0] iout2_frac,

    output reg signed   [15:0] rout3_whole, 
    output reg         [15:0] rout3_frac, 
    output reg signed   [15:0] iout3_whole, 
    output reg         [15:0] iout3_frac,

    output reg signed   [15:0] rout4_whole, 
    output reg         [15:0] rout4_frac, 
    output reg signed   [15:0] iout4_whole, 
    output reg         [15:0] iout4_frac,

    output reg signed   [15:0] rout5_whole, 
    output reg         [15:0] rout5_frac, 
    output reg signed   [15:0] iout5_whole, 
    output reg         [15:0] iout5_frac,

    output reg signed   [15:0] rout6_whole, 
    output reg         [15:0] rout6_frac, 
    output reg signed   [15:0] iout6_whole, 
    output reg         [15:0] iout6_frac,

    output reg signed   [15:0] rout7_whole, 
    output reg         [15:0] rout7_frac, 
    output reg signed   [15:0] iout7_whole, 
    output reg         [15:0] iout7_frac

   );

    function [7:0] extract_2_digits;
        input [15:0] frac_in;
        integer temp;
        begin
            temp = frac_in;
            while (temp >= 100)
                temp = temp / 10;
            extract_2_digits = temp[7:0];
        end
    endfunction

//New dec_arith
    task dec_arith;
        input  signed [15:0] A_whole;
        input         [15:0] A_frac;
        input  signed [15:0] B_whole;
        input         [15:0] B_frac;
        input       [1:0]  op_sel;
        input [0:0] flagA;
        input [0:0] flagB;
        
        //VERY IMPORTANT
        // IF 0 whole number is passed, it cannot differntiate whether +Ve or _ve thats 
        //thats y if flag=1 means whole no=0 and numbr is negative
        output signed [15:0] result_whole;
        output        [15:0] result_frac;
        output[0:0] flagResult;
        reg signed [31:0] A_fixed, B_fixed, R_fixed;
        reg signed [31:0] temp_frac;
    begin
        if(flagA==0&&flagB==0)begin
        A_fixed = A_whole * 100 + ((A_whole < 0) ? -$signed(extract_2_digits(A_frac)) : $signed(extract_2_digits(A_frac)));
        B_fixed = B_whole * 100 + ((B_whole < 0) ? -$signed(extract_2_digits(B_frac)) : $signed(extract_2_digits(B_frac)));
        end
        
        else if(flagA==1 && flagB==0) begin
        A_fixed = -$signed(extract_2_digits(A_frac));
        B_fixed = B_whole * 100 + ((B_whole < 0) ? -$signed(extract_2_digits(B_frac)) : $signed(extract_2_digits(B_frac)));        
        end
        
        else if(flagB==1&&flagA==0) begin
        B_fixed = -$signed(extract_2_digits(B_frac));
        A_fixed = A_whole * 100 + ((A_whole < 0) ? -$signed(extract_2_digits(A_frac)) : $signed(extract_2_digits(A_frac)));        
        end
        
        else begin
        A_fixed = -$signed(extract_2_digits(A_frac));
        B_fixed = -$signed(extract_2_digits(B_frac));
        end 
        
        case (op_sel)
            2'b00: R_fixed = A_fixed + B_fixed;
            2'b01: R_fixed = A_fixed - B_fixed;
            2'b10: R_fixed = (A_fixed * B_fixed) / 100;
            default: R_fixed = 0;
        endcase
        
        if(R_fixed<0 && R_fixed >-100)begin
        flagResult=1;
        end
        else begin
        flagResult=0;
        end
        result_whole = R_fixed / 100;
        temp_frac = R_fixed % 100;
        result_frac = (temp_frac < 0) ? -temp_frac[15:0] : temp_frac[15:0];
    end
    endtask

    // Input buffer registers
    reg signed [15:0] Rin0_whole; reg [15:0] Rin0_frac;
    reg signed [15:0] Rin1_whole; reg [15:0] Rin1_frac;
    reg signed [15:0] Rin2_whole; reg [15:0] Rin2_frac;
    reg signed [15:0] Rin3_whole; reg [15:0] Rin3_frac;
    reg signed [15:0] Rin4_whole; reg [15:0] Rin4_frac;
    reg signed [15:0] Rin5_whole; reg [15:0] Rin5_frac;
    reg signed [15:0] Rin6_whole; reg [15:0] Rin6_frac;
    reg signed [15:0] Rin7_whole; reg [15:0] Rin7_frac;

    // First stage FFT (f) real and imag
    reg signed [15:0] fr0_whole; reg [15:0] fr0_frac;
    reg signed [15:0] fr1_whole; reg [15:0] fr1_frac;
    reg signed [15:0] fr2_whole; reg [15:0] fr2_frac;
    reg signed [15:0] fr3_whole; reg [15:0] fr3_frac;
    reg signed [15:0] fr4_whole; reg [15:0] fr4_frac;
    reg signed [15:0] fr5_whole; reg [15:0] fr5_frac;
    reg signed [15:0] fr6_whole; reg [15:0] fr6_frac;
    reg signed [15:0] fr7_whole; reg [15:0] fr7_frac;

    // Second stage FFT (s) real and imag
    reg signed [15:0] sr0_whole; reg [15:0] sr0_frac;
    reg signed [15:0] sr1_whole; reg [15:0] sr1_frac;
    reg signed [15:0] sr2_whole; reg [15:0] sr2_frac;
    reg signed [15:0] sr3_whole; reg [15:0] sr3_frac;
    reg signed [15:0] sr4_whole; reg [15:0] sr4_frac;
    reg signed [15:0] sr5_whole; reg [15:0] sr5_frac;
    reg signed [15:0] sr6_whole; reg [15:0] sr6_frac;
    reg signed [15:0] sr7_whole; reg [15:0] sr7_frac;

    reg signed [15:0] si0_whole; reg [15:0] si0_frac;
    reg signed [15:0] si1_whole; reg [15:0] si1_frac;
    reg signed [15:0] si2_whole; reg [15:0] si2_frac;
    reg signed [15:0] si3_whole; reg [15:0] si3_frac;
    reg signed [15:0] si4_whole; reg [15:0] si4_frac;
    reg signed [15:0] si5_whole; reg [15:0] si5_frac;
    reg signed [15:0] si6_whole; reg [15:0] si6_frac;
    reg signed [15:0] si7_whole; reg [15:0] si7_frac;

reg [0:0] Rin0_flag;
reg [0:0] Rin1_flag;
reg [0:0] Rin2_flag;
reg [0:0] Rin3_flag;
reg [0:0] Rin4_flag;
reg [0:0] Rin5_flag;
reg [0:0] Rin6_flag;
reg [0:0] Rin7_flag;

reg [0:0] fr0_flag;
reg [0:0] fr1_flag;
reg [0:0] fr2_flag;
reg [0:0] fr3_flag;
reg [0:0] fr4_flag;
reg [0:0] fr5_flag;
reg [0:0] fr6_flag;
reg [0:0] fr7_flag;

reg [0:0] sr0_flag;
reg [0:0] sr1_flag;
reg [0:0] sr2_flag;
reg [0:0] sr3_flag;
reg [0:0] sr4_flag;
reg [0:0] sr5_flag;
reg [0:0] sr6_flag;
reg [0:0] sr7_flag;

reg [0:0] si0_flag;
reg [0:0] si1_flag;
reg [0:0] si2_flag;
reg [0:0] si3_flag;
reg [0:0] si4_flag;
reg [0:0] si5_flag;
reg [0:0] si6_flag;
reg [0:0] si7_flag;
 //------------------------------------------------------------------
 
    // Task to multiply 2 complex numbers
    task CMul;
    
    //All were [17:0] initially
    input  reg signed [15:0] r1RealWhole;  // Real whole part of input 1
    input  reg  [15:0] r1RealFrac;   // Real frac part of input 1
    input  reg signed [15:0] r1ImagWhole;  // Imag whole part of input 1
    input  reg  [15:0] r1ImagFrac;   // Imag frac part of input 1

    input  reg signed [15:0] r2RealWhole;  // Real whole part of input 2
    input  reg  [15:0] r2RealFrac;   // Real frac part of input 2
    input  reg signed [15:0] r2ImagWhole;  // Imag whole part of input 2
    input  reg  [15:0] r2ImagFrac;   // Imag frac part of input 2

    input reg r1RealFlag;
    input reg r1ImagFlag;
    input reg r2RealFlag;
    input reg r2ImagFlag;
    
    output reg signed [15:0] roRealWhole;  // Real whole part of output
    output reg  [15:0] roRealFrac;   // Real frac part of output
    output reg signed [15:0] roImagWhole;  // Imag whole part of output
    output reg  [15:0] roImagFrac;   // Imag frac part of output

    output reg roRealFlag;
    output reg roImagFlag;
    
    reg signed [15:0] xWhole; 
    reg   [15:0] xFrac;
    reg xFlag;
    
    reg signed [15:0] yWhole;
    reg   [15:0] yFrac;
    reg yFlag;
    
    reg signed [15:0] zWhole;
    reg   [15:0] zFrac;
    reg zFlag;
 
    reg signed [15:0] wWhole;
    reg   [15:0] wFrac;
    reg wFlag;
    
    begin
        // ac
        dec_arith(r1RealWhole, r1RealFrac, r2RealWhole, r2RealFrac, 2'b10,r1RealFlag,r2RealFlag, xWhole, xFrac, xFlag);
        // bd
        dec_arith(r1ImagWhole, r1ImagFrac, r2ImagWhole, r2ImagFrac, 2'b10,r1ImagFlag,r2ImagFlag, yWhole, yFrac, yFlag);
        // ad
        dec_arith(r1RealWhole, r1RealFrac, r2ImagWhole, r2ImagFrac, 2'b10,r1RealFlag,r2ImagFlag, zWhole, zFrac, zFlag);
        // bc
        dec_arith(r1ImagWhole, r1ImagFrac, r2RealWhole, r2RealFrac, 2'b10,r1ImagFlag,r2RealFlag, wWhole, wFrac, wFlag);

        // real = ac - bd
        dec_arith(xWhole, xFrac, yWhole, yFrac, 2'b01,xFlag,yFlag, roRealWhole, roRealFrac,roRealFlag);
        // imag = ad + bc
        dec_arith(zWhole, zFrac, wWhole, wFrac, 2'b00,zFlag,wFlag, roImagWhole, roImagFrac,roImagFlag);

    
    end
    endtask

    task CMul_707_j707;
    // Multiply by (0.707 - j0.707) 
    inout  reg signed [15:0] arWhole;  // Real whole part of input A
    inout  reg [15:0] arFrac;   // Real frac part of input A
    
    inout  reg signed [15:0] aiWhole;  // Imag whole part of input A
    inout  reg  [15:0] aiFrac;   // Imag frac part of input A

    inout reg [0:0]arFlag;
    inout reg [0:0]aiFlag;
     reg signed [15:0] roWhole;  // Real whole part of output
     reg  [15:0] roFrac;   // Real frac part of output

     reg signed [15:0] ioWhole;  // Imag whole part of output
     reg  [15:0] ioFrac;   // Imag frac part of output
      reg [0:0]roFlag;
      reg [0:0]ioFlag;
     
    begin
    // Multiply by (0.707 - j0.707) 
    CMul(arWhole,arFrac, aiWhole, aiFrac,16'sd0,16'd70,16'sd0,16'd70, arFlag, aiFlag, 1'b0,1'b1,roWhole,roFrac,ioWhole,ioFrac,roFlag,ioFlag);
    arWhole=roWhole;
    arFrac=roFrac;
    aiWhole=ioWhole;
    aiFrac=ioFrac;
    arFlag=roFlag;
    aiFlag=ioFlag;
    end
    endtask     

    task CMul_minus707_j707;   
    // Multiply by (-0.707 - j0.707) 
    inout  reg signed [15:0] arWhole;  // Real whole part of input A
    inout  reg [15:0] arFrac;   // Real frac part of input A
    
    inout  reg signed [15:0] aiWhole;  // Imag whole part of input A
    inout  reg  [15:0] aiFrac;   // Imag frac part of input A

    inout reg [0:0]arFlag;
    inout reg [0:0]aiFlag;
     reg signed [15:0] roWhole;  // Real whole part of output
     reg  [15:0] roFrac;   // Real frac part of output

     reg signed [15:0] ioWhole;  // Imag whole part of output
     reg  [15:0] ioFrac;   // Imag frac part of output
      reg [0:0]roFlag;
      reg [0:0]ioFlag;
     
    begin
    // Multiply by (-0.707 - j0.707) 
    CMul(arWhole,arFrac, aiWhole, aiFrac,16'sd0,16'd70,16'sd0,16'd70, arFlag, aiFlag, 1'b1,1'b1,roWhole,roFrac,ioWhole,ioFrac,roFlag,ioFlag);
    arWhole=roWhole;
    arFrac=roFrac;
    aiWhole=ioWhole;
    aiFrac=ioFrac;
    arFlag=roFlag;
    aiFlag=ioFlag;
    end
    endtask     


always @(posedge clk or posedge rst) begin
    if (rst) begin
        Rin0_whole <= 0; Rin0_frac <= 0;
    Rin1_whole <= 0; Rin1_frac <= 0;
    Rin2_whole <= 0; Rin2_frac <= 0;
    Rin3_whole <= 0; Rin3_frac <= 0;
    Rin4_whole <= 0; Rin4_frac <= 0;
    Rin5_whole <= 0; Rin5_frac <= 0;
    Rin6_whole <= 0; Rin6_frac <= 0;
    Rin7_whole <= 0; Rin7_frac <= 0;
    
    Rin0_flag <= 0;
    Rin1_flag <= 0;
    Rin2_flag <= 0;
    Rin3_flag <= 0;
    Rin4_flag <= 0;
    Rin5_flag <= 0;
    Rin6_flag <= 0;
    Rin7_flag <= 0;


    end else begin
    Rin0_whole <= rin0_whole; Rin0_frac <= rin0_frac;
    Rin1_whole <= rin4_whole; Rin1_frac <= rin4_frac;
    Rin2_whole <= rin2_whole; Rin2_frac <= rin2_frac;
    Rin3_whole <= rin6_whole; Rin3_frac <= rin6_frac;
    Rin4_whole <= rin1_whole; Rin4_frac <= rin1_frac;
    Rin5_whole <= rin5_whole; Rin5_frac <= rin5_frac;
    Rin6_whole <= rin3_whole; Rin6_frac <= rin3_frac;
    Rin7_whole <= rin7_whole; Rin7_frac <= rin7_frac;  
   
    Rin0_flag <= rin0_flag;
    Rin1_flag <= rin4_flag;
    Rin2_flag <= rin2_flag;
    Rin3_flag <= rin6_flag;
    Rin4_flag <= rin1_flag;
    Rin5_flag <= rin5_flag;
    Rin6_flag <= rin3_flag;
    Rin7_flag <= rin7_flag;
   
    end
end



    always @(posedge clk or posedge rst) begin

        // fr0 = Rin0 + Rin1; 
        dec_arith(Rin0_whole, Rin0_frac, Rin1_whole, Rin1_frac, 2'b00,Rin0_flag,Rin1_flag, fr0_whole, fr0_frac, fr0_flag); 

        // fr1 = Rin0 - Rin1; 
        dec_arith(Rin0_whole, Rin0_frac, Rin1_whole, Rin1_frac, 2'b01,Rin0_flag,Rin1_flag, fr1_whole, fr1_frac, fr1_flag); 

        // fr2 = Rin2 + Rin3; 
        dec_arith(Rin2_whole, Rin2_frac, Rin3_whole, Rin3_frac, 2'b00,Rin2_flag,Rin3_flag, fr2_whole, fr2_frac, fr2_flag); 

        // fr3 = Rin2 - Rin3;
        dec_arith(Rin2_whole, Rin2_frac, Rin3_whole, Rin3_frac, 2'b01, Rin2_flag, Rin3_flag, fr3_whole, fr3_frac, fr3_flag);

        // fr4 = Rin4 + Rin5;
        dec_arith(Rin4_whole, Rin4_frac, Rin5_whole, Rin5_frac, 2'b00, Rin4_flag, Rin5_flag, fr4_whole, fr4_frac, fr4_flag);

        // fr5 = Rin4 - Rin5;
        dec_arith(Rin4_whole, Rin4_frac, Rin5_whole, Rin5_frac, 2'b01, Rin4_flag, Rin5_flag, fr5_whole, fr5_frac, fr5_flag);

        // fr6 = Rin6 + Rin7;
        dec_arith(Rin6_whole, Rin6_frac, Rin7_whole, Rin7_frac, 2'b00, Rin6_flag, Rin7_flag, fr6_whole, fr6_frac, fr6_flag);

        // fr7 = Rin6 - Rin7;
        dec_arith(Rin6_whole, Rin6_frac, Rin7_whole, Rin7_frac, 2'b01, Rin6_flag, Rin7_flag, fr7_whole, fr7_frac, fr7_flag);
        
        //DEBUGGING 
        /*
        FR0_whole = fr0_whole;
        FR0_frac  = fr0_frac;

        FR1_whole = fr1_whole;
        FR1_frac  = fr1_frac;

        FR2_whole = fr2_whole;
        FR2_frac  = fr2_frac;

        FR3_whole = fr3_whole;
        FR3_frac  = fr3_frac;

        FR4_whole = fr4_whole;
        FR4_frac  = fr4_frac;

        FR5_whole = fr5_whole;
        FR5_frac  = fr5_frac;

        FR6_whole = fr6_whole;
        FR6_frac  = fr6_frac;

        FR7_whole = fr7_whole;
        FR7_frac  = fr7_frac;
        */
     
 //---------------------------------------------------------------------     
        //start of 2nd stage
       
        // sr0 = fr0 + fr2;
        dec_arith(fr0_whole, fr0_frac, fr2_whole, fr2_frac, 2'b00, fr0_flag, fr2_flag, sr0_whole, sr0_frac, sr0_flag);


        si0_whole = 0;
        si0_frac=0;
        si0_flag=0;
       
        //sr1 = fr1;
        sr1_whole = fr1_whole;
        sr1_frac=fr1_frac;
        sr1_flag=fr1_flag;
        

        //si1 = fr3 * -1;
        si1_whole=fr3_whole*-1;
        si1_frac=fr3_frac;
        si1_flag=fr3_flag*-1;
       
        // sr2 = fr0 - fr2;
        dec_arith(fr0_whole, fr0_frac, fr2_whole, fr2_frac, 2'b01, fr0_flag, fr2_flag, sr2_whole, sr2_frac, sr2_flag);
        
        //si2 = 0;
        si2_whole=0;
        si2_frac=0;
        si2_flag=0;
       
        //sr3 = fr1;
        sr3_whole=fr1_whole;
        sr3_frac=fr1_frac;
        sr3_flag=fr1_flag;
        
        //si3 = 1 * fr3;
        si3_whole=fr3_whole;
        si3_frac=fr3_frac;
        si3_flag=fr3_flag;
        //Confusion point, double multiplication with -1
       
        // sr4 = fr4 + fr6;
        dec_arith(fr4_whole, fr4_frac, fr6_whole, fr6_frac, 2'b00, fr4_flag, fr6_flag, sr4_whole, sr4_frac, sr4_flag);



        //si4 = 0;
        si4_whole=0;
        si4_frac=0;
        si4_flag=0;
       
        //sr5 = fr5;
        sr5_whole=fr5_whole;
        sr5_frac=fr5_frac;
        sr5_flag=fr5_flag;
        
        //si5 = -1 * fr7;
       si5_whole=fr7_whole*-1;
       si5_frac=fr7_frac;
       si5_flag=fr7_flag*-1;
       
        // sr6 = fr4 - fr6;
        dec_arith(fr4_whole, fr4_frac, fr6_whole, fr6_frac, 2'b01, fr4_flag, fr6_flag, sr6_whole, sr6_frac, sr6_flag);       
        //si6 = 0;
        si6_whole=0;
        si6_frac=0;
        si6_flag=0;
       
        //sr7 = fr5;
        sr7_whole=fr5_whole;
        sr7_frac=fr5_frac;
        sr7_flag=fr5_flag;
        
        //si7 = 1 * fr7;
        si7_whole=fr7_whole;
        si7_frac=fr7_frac;
        si7_flag=fr7_flag;
        
       
        //Confusion point, double multiplication with -1
       
        //Important multiplications with complex numbers before 3rd stage

        CMul_707_j707(sr5_whole,sr5_frac,si5_whole,si5_frac,sr5_flag,si5_flag);
        CMul_minus707_j707(sr7_whole,sr7_frac,si7_whole,si7_frac,sr7_flag,si7_flag);
       
       //CMul(sr6,si6,0,-1,sr6,si6);
        CMul(sr6_whole,sr6_frac,si6_whole,si6_frac,16'sd0,16'd0,-16'sd1,16'd0,sr6_flag,si6_flag,1'b0,1'b0,sr6_whole,sr6_frac,si6_whole,si6_frac,sr6_flag,si6_flag);
  
//------------------------------------------------------------------------
        // start of 3rd step
        
        // rout0 = sr0 + sr4;
        dec_arith(sr0_whole, sr0_frac, sr4_whole, sr4_frac, 2'b00, sr0_flag, sr4_flag, rout0_whole, rout0_frac, rout0_flag);
       
        
        //iout0=0;
        iout0_whole=0;
        iout0_frac=0;
        iout0_flag=0;
        
       
        // rout1 = sr1 + sr5;
        dec_arith(sr1_whole, sr1_frac, sr5_whole, sr5_frac, 2'b00, sr1_flag, sr5_flag, rout1_whole, rout1_frac, rout1_flag);

        // iout1 = si1 + si5;
        dec_arith(si1_whole, si1_frac, si5_whole, si5_frac, 2'b00, si1_flag, si5_flag, iout1_whole, iout1_frac, iout1_flag);

        // rout2 = sr2 + sr6;
        dec_arith(sr2_whole, sr2_frac, sr6_whole, sr6_frac, 2'b00, sr2_flag, sr6_flag, rout2_whole, rout2_frac, rout2_flag);

        // iout2 = si2 + si6;
        dec_arith(si2_whole, si2_frac, si6_whole, si6_frac, 2'b00, si2_flag, si6_flag, iout2_whole, iout2_frac, iout2_flag);

        // rout3 = sr3 + sr7;
        dec_arith(sr3_whole, sr3_frac, sr7_whole, sr7_frac, 2'b00, sr3_flag, sr7_flag, rout3_whole, rout3_frac, rout3_flag);

        // iout3 = si3 + si7;
        dec_arith(si3_whole, si3_frac, si7_whole, si7_frac, 2'b00, si3_flag, si7_flag, iout3_whole, iout3_frac, iout3_flag);

        // rout4 = sr0 - sr4;
        dec_arith(sr0_whole, sr0_frac, sr4_whole, sr4_frac, 2'b01, sr0_flag, sr4_flag, rout4_whole, rout4_frac, rout4_flag);
        //iout4=0;
        iout4_whole=0;
        iout4_frac=0;
        iout4_flag=0;
       
        // rout5 = sr1 - sr5;
        dec_arith(sr1_whole, sr1_frac, sr5_whole, sr5_frac, 2'b01, sr1_flag, sr5_flag, rout5_whole, rout5_frac, rout5_flag);

        // iout5 = si1 - si5;
        dec_arith(si1_whole, si1_frac, si5_whole, si5_frac, 2'b01, si1_flag, si5_flag, iout5_whole, iout5_frac, iout5_flag);

        // rout6 = sr2 - sr6;
        dec_arith(sr2_whole, sr2_frac, sr6_whole, sr6_frac, 2'b01, sr2_flag, sr6_flag, rout6_whole, rout6_frac, rout6_flag);

        // iout6 = si2 - si6;
        dec_arith(si2_whole, si2_frac, si6_whole, si6_frac, 2'b01, si2_flag, si6_flag, iout6_whole, iout6_frac, iout6_flag);

        // rout7 = sr3 - sr7;
        dec_arith(sr3_whole, sr3_frac, sr7_whole, sr7_frac, 2'b01, sr3_flag, sr7_flag, rout7_whole, rout7_frac, rout7_flag);

        // iout7 = si3 - si7;
        dec_arith(si3_whole, si3_frac, si7_whole, si7_frac, 2'b01, si3_flag, si7_flag, iout7_whole, iout7_frac, iout7_flag);    
    end
endmodule
