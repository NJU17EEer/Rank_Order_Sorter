`timescale 1 ns/ 1 ns

`define PERIOD (10)


module tb();
/********** 1. ports and signal declaration **********/
  parameter WIDTH = 4;
  reg  [(WIDTH - 1):0] mag_in  [0:3];
  wire [(WIDTH - 1):0] min_out [0:1];
/********** 2. module instantiation and assignment **********/
  rank_order_sorter #(
    .WIDTH (WIDTH)
  ) uut (
    .mag_in  (mag_in  ),
    .min_out (min_out )
  );
/********** 3. Initialization **********/
  initial begin
    for (int i = 0; i < 4; i = i + 1) begin
      mag_in[i] = $random;
    end
    
    #(10);
    
    for (int i = 0; i < 2; i = i + 1) begin
      $display("min_out[%d] = %d", i, min_out[i]);
    end
    
    $stop(2);
  end

/********** 4. check part **********/
  
endmodule
