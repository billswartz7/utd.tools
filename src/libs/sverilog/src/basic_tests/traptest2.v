/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : L-2016.03-SP3
// Date      : Thu Feb 14 17:28:56 2019
/////////////////////////////////////////////////////////////


module mul_trap_0211 ( a, b, out );
  input [3:0] a;
  input [3:0] b;
  output [7:0] out;
  wire   n1, n2 ;

//  AND2 U1 ( .A(q[1][34][3].s1[1]), .B(a[0]), .O(out[0]) );
//  AND2 U1 ( .A(q[1][34][3].s1[1].r1[1:3]), .B(a[0]), .O(out[0]) );
  AND2 U2 ( .A(b[1]), .B(a[0]), .O(n1) );
  AND2 U3 ( .A(b[0]), .B(a[1]), .O(n2) );
  MUXI_B U4 ( .B(n1), .A(n1), .S(n2), .O(out[1]) );
  AND2 U5 ( .A(b[0]), .B(a[2]), .O(n10) );
  AND2 U6 ( .A(a[0]), .B(b[2]), .O(n5) );
  AND2 U7 ( .A(b[1]), .B(a[1]), .O(n6) );
  MUXI_B U8 ( .B(n5), .A(n5), .S(n6), .O(n9) );
  AND2 U9 ( .A(n2), .B(n1), .O(n7) );
  MUXI_B U10 ( .B(n9), .A(n9), .S(n7), .O(n3) );
  MUXI_B U11 ( .B(n10), .A(n10), .S(n3), .O(out[2]) );
  AND2 U12 ( .A(a[1]), .B(b[2]), .O(n26) );
  AND2 U13 ( .A(b[0]), .B(a[3]), .O(n28) );
  AND2 U14 ( .A(a[0]), .B(b[3]), .O(n22) );
  NAND2 U15 ( .A(b[1]), .B(a[2]), .O(n24) );
  MUX_B U16 ( .B(n22), .A(n22), .S(n24), .O(n27) );
  MUXI_B U17 ( .B(n28), .A(n28), .S(n27), .O(n4) );
  MUX_B U18 ( .B(n26), .A(n26), .S(n4), .O(n21) );
  AND2 U19 ( .A(n6), .B(n5), .O(n16) );
  OAI21 U20 ( .A(a[2]), .B(n9), .C(n7), .O(n11) );
  INV U21 ( .A(n11), .O(n8) );
  NAND2 U22 ( .A(n16), .B(n8), .O(n20) );
  AND2 U23 ( .A(n10), .B(n9), .O(n13) );
  INV U24 ( .A(n11), .O(n12) );
  NOR2 U25 ( .A(n13), .B(n12), .O(n14) );
  INV U26 ( .A(n14), .O(n15) );
  NOR2 U27 ( .A(n16), .B(n15), .O(n19) );
  INV U28 ( .A(n19), .O(n17) );
  NAND2 U29 ( .A(n20), .B(n17), .O(n18) );
  MUXI_B U30 ( .B(n21), .A(n21), .S(n18), .O(out[3]) );
  AOI21 U31 ( .A(n21), .B(n20), .C(n19), .O(n39) );
  NAND2 U32 ( .A(a[2]), .B(b[2]), .O(n31) );
  INV U33 ( .A(n31), .O(n54) );
  AND2 U34 ( .A(a[1]), .B(b[3]), .O(n46) );
  MUX U35 ( .B(n54), .A(n31), .S(n46), .O(n43) );
  INV U36 ( .A(n22), .O(n23) );
  NOR2 U37 ( .A(n24), .B(n23), .O(n44) );
  AND2 U38 ( .A(b[1]), .B(a[3]), .O(n42) );
  MUXI_B U39 ( .B(n44), .A(n44), .S(n42), .O(n25) );
  MUXI_B U40 ( .B(n43), .A(n43), .S(n25), .O(n41) );
  MAJI U41 ( .A(n28), .B(n27), .C(n26), .O(n38) );
  MUX_B U42 ( .B(n41), .A(n41), .S(n38), .O(n29) );
  MUXI_B U43 ( .B(n39), .A(n39), .S(n29), .O(out[4]) );
  AND2 U44 ( .A(b[2]), .B(a[3]), .O(n37) );
  INV U45 ( .A(n46), .O(n30) );
  NOR2 U46 ( .A(n31), .B(n30), .O(n32) );
  INV U47 ( .A(n32), .O(n33) );
  NAND2 U48 ( .A(a[2]), .B(n33), .O(n34) );
  INV U49 ( .A(n34), .O(n35) );
  NAND2 U50 ( .A(b[3]), .B(n35), .O(n36) );
  MUXI_B U51 ( .B(n37), .A(n37), .S(n36), .O(n47) );
  INV U52 ( .A(n38), .O(n40) );
  MAJI U53 ( .A(n41), .B(n40), .C(n39), .O(n49) );
  AOOAI212 U54 ( .A(a[3]), .B(n44), .C(n43), .D(n44), .E(n42), .O(n48) );
  MUX_B U55 ( .B(n49), .A(n49), .S(n48), .O(n45) );
  MUXI_B U56 ( .B(n47), .A(n47), .S(n45), .O(out[5]) );
  AND2 U57 ( .A(b[3]), .B(a[3]), .O(n52) );
  OAI21 U58 ( .A(n52), .B(n46), .C(n54), .O(n51) );
  MAJI U59 ( .A(n49), .B(n48), .C(n47), .O(n53) );
  MUXI_B U60 ( .B(n52), .A(n52), .S(n53), .O(n50) );
  MUX_B U61 ( .B(n51), .A(n51), .S(n50), .O(out[6]) );
  OA21 U62 ( .A(n54), .B(n53), .C(n52), .O(out[7]) );
endmodule

