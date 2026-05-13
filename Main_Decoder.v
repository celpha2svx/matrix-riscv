module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp,MAC_Enable);
    input [6:0]Op;
    output RegWrite,ALUSrc,MemWrite,Branch;
    output [1:0]ImmSrc,ALUOp;
    output [1:0]ResultSrc;
    output MAC_Enable;

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0010011 | Op == 7'b0110011 | Op == 7'b0001011) ? 1'b1 : 1'b0 ;
    assign ImmSrc   = (Op == 7'b0100011) ? 2'b01 :
                      (Op == 7'b1100011) ? 2'b10 :
                                           2'b00 ;
    assign ALUSrc   = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 : 1'b0 ;
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 : 1'b0 ;
    assign ResultSrc = (Op == 7'b0000011) ? 2'b01 :
                       (Op == 7'b0001011) ? 2'b10 :
                                            2'b00 ;
    assign Branch   = (Op == 7'b1100011) ? 1'b1 : 1'b0 ;
    assign ALUOp    = (Op == 7'b0010011) ? 2'b10 :
                      (Op == 7'b0110011) ? 2'b10 :
                      (Op == 7'b1100011) ? 2'b01 :
                                           2'b00 ;
    assign MAC_Enable = (Op == 7'b0001011) ? 1'b1 : 1'b0 ;

endmodule

