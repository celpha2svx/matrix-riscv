module Register_File(clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0]A1,A2,A3;
    input [31:0]WD3;
    output [31:0]RD1,RD2;

    reg [31:0] Register [31:0];
    integer i;

    always @ (negedge clk)
    begin
        if(WE3)
            Register[A3] <= WD3;
    end

    assign RD1 = (~rst) ? 32'd0 : (A1 == 5'b00000) ? 32'd0 : Register[A1];
    assign RD2 = (~rst) ? 32'd0 : (A2 == 5'b00000) ? 32'd0 : Register[A2];


    initial begin
        for (i = 0; i < 32; i = i + 1)
            Register[i] = 32'h00000000;
        Register[5] = 32'h00000006;
        Register[6] = 32'h0000000A;
        $display("Register File initialized: R[5]=%h, R[6]=%h", Register[5], Register[6]);
    end
 
endmodule
