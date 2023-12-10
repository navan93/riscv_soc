module gf180_ram_512x8_wrapper (
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input CLK,
	input CEN,
	input GWEN,
	input [7:0] WEN,
	input [8:0] A,
	input [7:0] D,
	output [7:0] Q
);

gf180mcu_fd_ip_sram__sram512x8m8wm1 sram512x8 (
    .CLK    (CLK),
    .CEN    (CEN),
    .GWEN   (GWEN),
    .WEN    (WEN),
    .A      (A),
    .D      (D),
    .Q      (Q),
`ifdef USE_POWER_PINS
    .VDD    (VDD),
    .VSS    (VSS)
`endif
`ifndef USE_POWER_PINS
	.VDD(),
	.VSS()
`endif
);

endmodule