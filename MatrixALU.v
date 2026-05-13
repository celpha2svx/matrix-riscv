module MatrixALU(
    input  wire [31:0] inA,
    input  wire [31:0] inB,
    input  wire [31:0] acc_in,
    input  wire        enable,
    output reg  [31:0] result,
    output reg         negative,
    output reg         zero
);


    wire signed [31:0] opA = inA;
    wire signed [31:0] opB = inB;
    wire signed [63:0] product = opA * opB;

    always @(*) begin
        if (enable) begin
            result = acc_in + product[31:0];
        end else begin
            result = acc_in;
        end
        negative = result[31];
        zero     = (result == 32'h0);
    end

endmodule
