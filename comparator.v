module comparator(input [3:0] a, b, output wire A_eq_B, A_gt_B, A_lt_B);
wire [3:0]i; 
wire [3:0]t;

// Equal
xnor xn0(i[3],a[3],b[3]);
xnor xn1(i[2],a[2],b[2]);
xnor xn2(i[1],a[1],b[1]);
xnor xn3(i[0],a[0],b[0]);
and a1(A_eq_B,i[3],i[2],i[1],i[0]);

// Greater than
and a2(t[3],a[3],~b[3]);
and a3(t[2],i[3],a[2],~b[2]);
and a4(t[1],i[3],i[2],a[1],~b[1]);
and a5(t[0],i[3],i[2],i[1],a[0],~b[0]);
or r1(A_gt_B,t[3],t[2],t[1],t[0]);  

// Less than
assign A_lt_B = ~(A_eq_B | A_gt_B);
endmodule

module comparator_tb;
  reg [3:0]a,b;
  wire A_eq_B , A_lt_B , A_gt_B;
  
  comparator dut(.a(a),.b(b),.A_eq_B(A_eq_B),.A_lt_B(A_lt_B),.A_gt_B(A_gt_B)) ;
 
  initial begin
    $monitor("Time=%0t A=%b B=%b | EQ=%b | LT=%b | GT=%b", 
          $time, a, b, A_eq_B, A_lt_B, A_gt_B);
   
    a=4'b0000; b=4'b0000; #10; // equal
    a=4'b0001; b=4'b0010; #10; // less
    a=4'b0100; b=4'b0011; #10; // greater
    a=4'b1010; b=4'b1010; #10; // equal
    a=4'b1111; b=4'b0000; #10; // greater
    a=4'b0000; b=4'b1111; #10; // less
    a=4'b0110; b=4'b0111; #10; // less
    a=4'b1001; b=4'b0111; #10; // greater
    a=4'b0011; b=4'b0011; #10; // equal
    a=4'b0101; b=4'b1110; #10; // less

    $finish; 
  end
endmodule 
