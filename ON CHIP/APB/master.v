module apb_master(
    input              pclk, rst, transfer, pready,
    input      [31:0]  prdata,
    input              pwrite_in,  
    input      [7:0]   paddr_in,   
    input      [31:0]  pwdata_in, 
    output reg         psel, penable, pwrite,
    output reg [7:0]   paddr,
    output reg [31:0]  pwdata,
    output reg [31:0]  data_read_out 
);
 reg [1:0] state, next_state;
  parameter IDLE   = 2'b00;
  parameter SETUP  = 2'b01;
  parameter ACCESS = 2'b10;
  always @(posedge pclk or posedge rst) begin
    if (rst) state <= IDLE;
    else     state <= next_state;
  end
  always @(posedge pclk or posedge rst) begin
    if (rst) 
      data_read_out <= 32'h0;
    else if (state == ACCESS && pready && !pwrite) 
      data_read_out <= prdata;
  end
  always @(*) begin
    psel = 0; penable = 0; pwrite = pwrite_in;
    paddr = paddr_in; pwdata = pwdata_in;
    next_state = state;

    case (state)
      IDLE: begin
        if (transfer) next_state = SETUP;
      end
      
      SETUP: begin
        psel = 1;
        penable = 0;
        next_state = ACCESS;
      end
      
      ACCESS: begin
        psel = 1;
        penable = 1;
        if (pready) next_state = IDLE;
        else        next_state = ACCESS;
      end
      
      default: next_state = IDLE;
    endcase
  end
endmodule
