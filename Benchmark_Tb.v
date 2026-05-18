module Benchmark_Tb();

reg clk = 1'b1;
reg rst;
reg done;

integer total_instr, mac_count, reg_writes;

Single_Cycle_Top DUT(
    .clk(clk),
    .rst(rst)
);

always #50 clk = ~clk;

initial begin
    total_instr = 0;
    mac_count   = 0;
    reg_writes  = 0;
    done        = 0;
end

always @(posedge clk) begin
    if (rst && !done) begin

        if (DUT.RD_Instr === 32'h0000006f) begin
            done = 1;
            $display("");
            $display("========================================");
            $display("         BENCHMARK RESULTS              ");
            $display("========================================");
            $display("Total instructions executed : %0d", total_instr);
            $display("MAC instructions            : %0d", mac_count);
            $display("Register writes             : %0d", reg_writes);
            $display("Instruction memory traffic  : %0d bytes", total_instr * 4);
            $display("========================================");
            $finish;
        end

        total_instr = total_instr + 1;
        if (DUT.MAC_Enable)  mac_count  = mac_count + 1;
        if (DUT.RegWrite)    reg_writes = reg_writes + 1;

        $display("Cycle %0d: Instr=%h MAC=%b RegWrite=%b MACResult=%h",
            total_instr,
            DUT.RD_Instr,
            DUT.MAC_Enable,
            DUT.RegWrite,
            DUT.MACResult);
    end
end

initial begin
    rst = 0;
    #150;
    rst = 1;
    #5000;
    $finish;
end

endmodule
