module tb_apb();
  reg pclk;
  reg rst;
  reg transfer;
  reg pwrite_in;
  reg [7:0] paddr_in;
  reg [31:0] pwdata_in;
  wire [31:0] read_data_out;
  apb_top dut (
    .pclk(pclk),
    .rst(rst),
    .transfer(transfer),
    .pwrite_in(pwrite_in),
    .paddr_in(paddr_in),
    .pwdata_in(pwdata_in),
    .read_data_out(read_data_out)
  );
  always #5 pclk = ~pclk;
initial begin
    pclk = 0; rst = 1; transfer = 0; 
    pwrite_in = 0; paddr_in = 0; pwdata_in = 0;
    #15 rst = 0;
    @(posedge pclk);
    transfer  = 1;
    pwrite_in = 1;
    paddr_in  = 8'h02;
    pwdata_in = 32'hABCD1234;
 @(posedge pclk);
    transfer = 0;
    wait(dut.m1.state == 2'b00); 
#20; 
    @(posedge pclk);
    transfer  = 1;
    pwrite_in = 0;
    paddr_in  = 8'h02;

    @(posedge pclk);
    transfer = 0;
    wait(dut.m1.state == 2'b00);


    #110 $finish;
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_apb);
  end

endmodule
