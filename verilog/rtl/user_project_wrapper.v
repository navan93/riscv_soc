// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input                       wb_clk_i,   // System clock
    input                       wb_rst_i,   // Regular Reset signal
    input                       wbs_stb_i,  // strobe/request
    input                       wbs_cyc_i,  // strobe/request
    input                       wbs_we_i,   // write
    input  [3:0]                wbs_sel_i,  // byte enable
    input  [31:0]               wbs_dat_i,  // data input
    input  [31:0]               wbs_adr_i,  // address
    output                      wbs_ack_o,  // acknowlegement
    output [31:0]               wbs_dat_o,  // data output

    // Logic Analyzer Signals
    input  [63:0]               la_data_in,
    output [63:0]               la_data_out,
    input  [63:0]               la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0]  io_in,
    output [`MPRJ_IO_PADS-1:0]  io_out,
    output [`MPRJ_IO_PADS-1:0]  io_oeb,

    // Independent clock (on independent integer divider)
    input                       user_clock2,

    // User maskable interrupt signals
    output [2:0]                user_irq
);

wire CEN_all;
wire [3:0] GWEN;
wire [7:0] WEN_all;
wire [8:0] A_all;
wire [7:0] D0;
wire [7:0] D1;
wire [7:0] D2;
wire [7:0] D3;
wire [7:0] Q0;
wire [7:0] Q1;
wire [7:0] Q2;
wire [7:0] Q3;

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

alpha_soc mprj (
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif

    .wb_clk_i   (wb_clk_i),
    .wb_rst_i   (wb_rst_i),

    // MGMT SoC Wishbone Slave
    .wbs_cyc_i  (wbs_cyc_i),
    .wbs_stb_i  (wbs_stb_i),
    .wbs_we_i   (wbs_we_i),
    .wbs_sel_i  (wbs_sel_i),
    .wbs_adr_i  (wbs_adr_i),
    .wbs_dat_i  (wbs_dat_i),
    .wbs_ack_o  (wbs_ack_o),
    .wbs_dat_o  (wbs_dat_o),

    // Logic Analyzer
    .la_data_in (la_data_in),
    .la_data_out(la_data_out),
    .la_oenb    (la_oenb),

    // IO Pads
    .io_i       (io_in),
    .io_out     (io_out),
    .io_oeb     (io_oeb),

    // IRQ
    .user_irq   (user_irq),

    //GF180 SRAM
    .gf180_sram_GWEN (GWEN),
    .gf180_sram_WEN  (WEN_all),
    .gf180_sram_CEN  (CEN_all),
    .gf180_sram_A    (A_all),
    .gf180_sram_D0   (D0),
    .gf180_sram_D1   (D1),
    .gf180_sram_D2   (D2),
    .gf180_sram_D3   (D3),
    .gf180_sram_Q0   (Q0),
    .gf180_sram_Q1   (Q1),
    .gf180_sram_Q2   (Q2),
    .gf180_sram_Q3   (Q3),
);

/*--------------------------------------*/
/* GF180 SRAM Hard Macros               */
/*--------------------------------------*/

gf180_ram_512x8_wrapper_as2650 sram0(
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (wb_clk_i),
    .CEN    (CEN_all),
    .WEN    (WEN_all),
    .A      (A_all),
    .D      (D0),
    .GWEN   (GWEN[0]),
    .Q      (Q0)
);

gf180_ram_512x8_wrapper_as2650 sram1(
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (wb_clk_i),
    .CEN    (CEN_all),
    .WEN    (WEN_all),
    .A      (A_all),
    .D      (D1),
    .GWEN   (GWEN[1]),
    .Q      (Q1)
);

gf180_ram_512x8_wrapper_as2650 sram2(
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (wb_clk_i),
    .CEN    (CEN_all),
    .WEN    (WEN_all),
    .A      (A_all),
    .D      (D2),
    .GWEN   (GWEN[2]),
    .Q      (Q2)
);

gf180_ram_512x8_wrapper_as2650 sram3(
`ifdef USE_POWER_PINS
    .VDD    (vdd),
    .VSS    (vss),
`endif
    .CLK    (wb_clk_i),
    .CEN    (CEN_all),
    .WEN    (WEN_all),
    .A      (A_all),
    .D      (D3),
    .GWEN   (GWEN[3]),
    .Q      (Q3)
);


endmodule	// user_project_wrapper

`default_nettype wire
