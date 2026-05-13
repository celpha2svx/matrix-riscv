module Single_Cycle_Top_Tb ();

    reg clk=1'b1,rst;
    wire [31:0] Result;
    wire MAC_Enable;
    wire [31:0] MACResult;
    wire [31:0] RD_Instr;
    integer cycle_count;

    Single_Cycle_Top Single_Cycle_Top(
        .clk(clk),
        .rst(rst)
    );

    // Connect to internal signals for monitoring
    assign Result = Single_Cycle_Top.Result;
    assign MAC_Enable = Single_Cycle_Top.MAC_Enable;
    assign MACResult = Single_Cycle_Top.MACResult;
    assign RD_Instr = Single_Cycle_Top.RD_Instr;

    initial begin
        $dumpfile("single_cycle.vcd");
        $dumpvars(0);
        cycle_count = 0;
    end

    always begin
        clk = ~clk;
        #50;
    end

    // Print results after reset
    always @(posedge clk) begin
      if (rst) begin
        cycle_count = cycle_count + 1;
        $display("Cycle %0d:", cycle_count);
        $display("  Instruction    = %h", Single_Cycle_Top.RD_Instr);
        $display("  RegWrite       = %b", Single_Cycle_Top.RegWrite);
        $display("  ResultSrc      = %b", Single_Cycle_Top.ResultSrc);
        $display("  MAC_Enable     = %b", Single_Cycle_Top.MAC_Enable);
        $display("  ALUResult      = %h", Single_Cycle_Top.ALUResult);
        $display("  MACResult      = %h", Single_Cycle_Top.MACResult);
        $display("  Result (write) = %h", Single_Cycle_Top.Result);
        $display("  RD1_Top        = %h", Single_Cycle_Top.RD1_Top);
        $display("  RD2_Top        = %h", Single_Cycle_Top.RD2_Top) ;
        $display("  SrcB           = %h", Single_Cycle_Top.SrcB);
        $display("  Imm_Ext_Top    = %h", Single_Cycle_Top.Imm_Ext_Top);
        $display("  ALUSrc         = %b", Single_Cycle_Top.ALUSrc);
        $display("  ALUControl_Top = %b", Single_Cycle_Top.ALUControl_Top);
        $display("  rst            = %b", rst);
        $display("");
        if (cycle_count > 10) $finish;
      end
    end  

    initial begin
        rst <= 1'b0;
        #150;
        rst <= 1'b1;
        #500;
        $display("Simulation finished.");
        $finish;
    end

endmodule

