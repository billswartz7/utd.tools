module iop_fpga(reset_l, gclk,
	spc_pcx_req_pq,
	spc_pcx_atom_pq,
	spc_pcx_data_pa,
	pcx_spc_grant_px,
	cpx_spc_data_rdy_cx2,
	cpx_spc_data_cx2
);

output	[4:0]	spc_pcx_req_pq;
output		spc_pcx_atom_pq;
output	[123:0]	spc_pcx_data_pa;

input	[4:0]	pcx_spc_grant_px;
input		cpx_spc_data_rdy_cx2;
input	[144:0]	cpx_spc_data_cx2;

input		reset_l;
input		gclk;


// WIRE Definitions for unused outputs
wire		spc_sscan_so;
wire		spc_scanout0;
wire		spc_scanout1;
wire		tst_ctu_mbist_done;
wire		tst_ctu_mbist_fail;
wire		spc_efc_ifuse_data;
wire		spc_efc_dfuse_data;

// WIRE Definitions for constraint
wire	[3:0]	const_cpuid = 4'b0000;
wire	[7:0]	const_maskid = 8'h20;
wire		ctu_tck = 1'b0;
wire		ctu_sscan_se = 1'b0;
wire		ctu_sscan_snap = 1'b0;
wire	[3:0]	ctu_sscan_tid = 4'h1;
wire		ctu_tst_mbist_enable = 1'b0;
wire		efc_spc_fuse_clk1 = 1'b0;
wire		efc_spc_fuse_clk2 = 1'b0;
wire		efc_spc_ifuse_ashift = 1'b0;
wire		efc_spc_ifuse_dshift = 1'b0;
wire		efc_spc_ifuse_data = 1'b0;
wire		efc_spc_dfuse_ashift = 1'b0;
wire		efc_spc_dfuse_dshift = 1'b0;
wire		efc_spc_dfuse_data = 1'b0;
wire		ctu_tst_macrotest = 1'b0;
wire		ctu_tst_scan_disable = 1'b0;
wire		ctu_tst_short_chain = 1'b0;
wire		global_shift_enable = 1'b0;
wire		ctu_tst_scanmode = 1'b0;
wire		spc_scanin0 = 1'b0;
wire		spc_scanin1 = 1'b0;

// Reset Related Signals
wire		cluster_cken;
wire		cmp_grst_l;
wire		cmp_arst_l;
wire		ctu_tst_pre_grst_l;
wire		adbginit_l;
wire		gdbginit_l;
reg		reset_l_int;
reg		sync;

// Reset Logic
assign cmp_arst_l = reset_l_int;
assign adbginit_l = reset_l_int;

reg [7:0] reset_delay;

// Synchronize the incoming reset net into the gclk domain
always @(posedge gclk) begin
  {reset_l_int, sync} <= {sync, reset_l};
end

always @(posedge gclk) begin
  if(~reset_l_int) begin
    reset_delay <= 8'b0;
  end else
    if(reset_delay != 8'hff)
      reset_delay <= reset_delay + 8'b1;
end

assign cluster_cken = (reset_delay > 8'd20) ? 1'b1 : 1'b0;
assign ctu_tst_pre_grst_l = (reset_delay > 8'd60) ? 1'b1 : 1'b0;
assign gdbginit_l = (reset_delay > 8'd120) ? 1'b1 : 1'b0;
assign cmp_grst_l = (reset_delay > 8'd120) ? 1'b1 : 1'b0;



sparc sparc0 (
	.spc_pcx_req_pq			(spc_pcx_req_pq),
	.spc_pcx_atom_pq		(spc_pcx_atom_pq),
	.spc_pcx_data_pa		(spc_pcx_data_pa),
	.spc_sscan_so			(spc_sscan_so),
	.spc_scanout0			(spc_scanout0),
	.spc_scanout1			(spc_scanout1),
	.tst_ctu_mbist_done		(tst_ctu_mbist_done),
	.tst_ctu_mbist_fail		(tst_ctu_mbist_fail),
	.spc_efc_ifuse_data		(spc_efc_ifuse_data),
	.spc_efc_dfuse_data		(spc_efc_dfuse_data),
	.pcx_spc_grant_px		(pcx_spc_grant_px),
	.cpx_spc_data_rdy_cx2		(cpx_spc_data_rdy_cx2),
	.cpx_spc_data_cx2		(cpx_spc_data_cx2),
	.const_cpuid			(const_cpuid),
	.const_maskid			(const_maskid),
	.ctu_tck			(ctu_tck),
	.ctu_sscan_se			(ctu_sscan_se),
	.ctu_sscan_snap			(ctu_sscan_snap),
	.ctu_sscan_tid			(ctu_sscan_tid),
	.ctu_tst_mbist_enable		(ctu_tst_mbist_enable),
	.efc_spc_fuse_clk1		(efc_spc_fuse_clk1),
	.efc_spc_fuse_clk2		(efc_spc_fuse_clk2),
	.efc_spc_ifuse_ashift		(efc_spc_ifuse_ashift),
	.efc_spc_ifuse_dshift		(efc_spc_ifuse_dshift),
	.efc_spc_ifuse_data		(efc_spc_ifuse_data),
	.efc_spc_dfuse_ashift		(efc_spc_dfuse_ashift),
	.efc_spc_dfuse_dshift		(efc_spc_dfuse_dshift),
	.efc_spc_dfuse_data		(efc_spc_dfuse_data),
	.ctu_tst_macrotest		(ctu_tst_macrotest),
	.ctu_tst_scan_disable		(ctu_tst_scan_disable),
	.ctu_tst_short_chain		(ctu_tst_short_chain),
	.global_shift_enable		(global_shift_enable),
	.ctu_tst_scanmode		(ctu_tst_scanmode),
	.spc_scanin0			(spc_scanin0),
	.spc_scanin1			(spc_scanin1),
	.cluster_cken			(cluster_cken),
	.gclk				(gclk),
	.cmp_grst_l			(cmp_grst_l),
	.cmp_arst_l			(cmp_arst_l),
	.ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
	.adbginit_l			(adbginit_l),
	.gdbginit_l			(gdbginit_l)
	);

endmodule

