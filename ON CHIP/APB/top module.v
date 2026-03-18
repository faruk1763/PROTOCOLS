module apb_top(
    input pclk, rst, transfer, pwrite_in,
    input [7:0] paddr_in,
    input [31:0] pwdata_in,
    output [31:0] read_data_out
);
  wire pready, psel, penable, pwrite;
  wire [31:0] pwdata, prdata;
  wire [7:0]  paddr;

  apb_master m1 (
    .pclk(pclk), .rst(rst), .transfer(transfer), .pready(pready),
    .prdata(prdata), .psel(psel), .penable(penable), 
    .pwrite(pwrite), .paddr(paddr), .pwdata(pwdata),
    .pwrite_in(pwrite_in), .paddr_in(paddr_in), .pwdata_in(pwdata_in),
    .data_read_out(read_data_out)
  );

  apb_slave s1 (
    .pclk(pclk), .rst(rst), .pwrite(pwrite), .penable(penable),
    .psel(psel), .pwdata(pwdata), .paddr(paddr), 
    .pready(pready), .prdata(prdata)
  );
endmodule
