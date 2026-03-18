module apb_slave(
    input              pclk, rst, pwrite, penable, psel,
    input      [31:0]  pwdata,
    input      [7:0]   paddr,
    output             pready,  
    output reg [31:0]  prdata
);
  reg [31:0] mem [7:0];
  integer i;
  assign pready = psel && penable;
always @(posedge pclk or posedge rst) begin
    if (rst) begin
      prdata <= 32'h0;
      for (i = 0; i < 8; i = i + 1) mem[i] <= 32'h0;
    end
    else if (psel && penable) begin
      if (pwrite) 
        mem[paddr[2:0]] <= pwdata;
      else        
        prdata <= mem[paddr[2:0]];
    end
  end
endmodule
