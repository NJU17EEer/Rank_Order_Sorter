module rank_order_sorter #(
  parameter WIDTH = 4
) (
  input      [(WIDTH - 1):0] mag_in  [0:3],
  output reg [(WIDTH - 1):0] min_out [0:1]
);
  
// comparison stage
wire [5:0] cmp_out;
assign cmp_out[0] = mag_in[0] < mag_in[1] ? 1'b0 : 1'b1;
assign cmp_out[1] = mag_in[0] < mag_in[2] ? 1'b0 : 1'b1;
assign cmp_out[2] = mag_in[0] < mag_in[3] ? 1'b0 : 1'b1;
assign cmp_out[3] = mag_in[1] < mag_in[2] ? 1'b0 : 1'b1;
assign cmp_out[4] = mag_in[1] < mag_in[3] ? 1'b0 : 1'b1;
assign cmp_out[5] = mag_in[2] < mag_in[3] ? 1'b0 : 1'b1;
wire [2:0] cmp_bit [0:3];
assign cmp_bit[0][0] = cmp_out[0];
assign cmp_bit[0][1] = cmp_out[1];
assign cmp_bit[0][2] = cmp_out[2];
assign cmp_bit[1][0] = ~cmp_out[0];
assign cmp_bit[1][1] = cmp_out[3];
assign cmp_bit[1][2] = cmp_out[4];
assign cmp_bit[2][0] = ~cmp_out[1];
assign cmp_bit[2][1] = ~cmp_out[3];
assign cmp_bit[2][2] = cmp_out[5];
assign cmp_bit[3][0] = ~cmp_out[2];
assign cmp_bit[3][1] = ~cmp_out[4];
assign cmp_bit[3][2] = ~cmp_out[5];
// rank computation stage
wire [1:0] rank [0:3];
assign rank[0] = cmp_bit[0][0] + cmp_bit[0][1] + cmp_bit[0][2];
assign rank[1] = cmp_bit[1][0] + cmp_bit[1][1] + cmp_bit[1][2];
assign rank[2] = cmp_bit[2][0] + cmp_bit[2][1] + cmp_bit[2][2];
assign rank[3] = cmp_bit[3][0] + cmp_bit[3][1] + cmp_bit[3][2];
// selection stage
genvar i;
generate
  for (i = 0; i < 2; i = i + 1) begin : SEL_GEN
    always_comb begin
      case(i)
        rank[0]: min_out[i] = mag_in[0];
        rank[1]: min_out[i] = mag_in[1];
        rank[2]: min_out[i] = mag_in[2];
        rank[3]: min_out[i] = mag_in[3];
        default: min_out[i] = 0;
      endcase
    end
  end
endgenerate

endmodule
