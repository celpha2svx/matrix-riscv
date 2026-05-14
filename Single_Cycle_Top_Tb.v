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
    integer mac_count, reg_write_count, total_instructions;

    initial begin
       mac_count = 0;
       reg_write_count = 0;
       total_instructions = 0;
    end

    always @(posedge clk) begin
      if (rst) begin
        total_instructions = total_instructions + 1;
        if (Single_Cycle_Top.MAC_Enable)
            mac_count = mac_count + 1;
        if (Single_Cycle_Top.RegWrite)
            reg_write_count = reg_write_count + 1;
        
        $display("Cycle %0d: Instr=%h MAC=%b RegWrite=%b MACResult=%h",
            total_instructions,
            Single_Cycle_Top.RD_Instr,
            Single_Cycle_Top.MAC_Enable,
            Single_Cycle_Top.RegWrite,
            Single_Cycle_Top.MACResult);
        
        if (total_instructions > 8) begin
            $display("");
            $display("=== BENCHMARK RESULTS ===");
            $display("Total instructions: %0d", total_instructions - 1);
            $display("MAC instructions:    %0d", mac_count);
            $display("Register writes:     %0d", reg_write_count);
            $display("Cycles (MACs):       %0d", mac_count);
            $display("Cycles (no-MAC est): %0d", mac_count * 2);
            $display("Instruction reduction: %0d%%", ((mac_count*2 - mac_count)*100)/(mac_count*2));
            $display("=========================");
            $finish;
        end
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

