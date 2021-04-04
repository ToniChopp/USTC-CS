
module mem #(                   // 
    parameter  ADDR_LEN  = 11   // 
) (
    input  clk, rst,
    input  [ADDR_LEN-1:0] addr, // memory address
    output reg [31:0] rd_data,  // data read out
    input  wr_req,
    input  [31:0] wr_data       // data write in
);
localparam MEM_SIZE = 1<<ADDR_LEN;
reg [31:0] ram_cell [MEM_SIZE];

always @ (posedge clk or posedge rst)
    if(rst)
        rd_data <= 0;
    else
        rd_data <= ram_cell[addr];

always @ (posedge clk)
    if(wr_req) 
        ram_cell[addr] <= wr_data;

initial begin
    // dst matrix C
    ram_cell[       0] = 32'h0;  // 32'h9921b236;
    ram_cell[       1] = 32'h0;  // 32'h46f92df6;
    ram_cell[       2] = 32'h0;  // 32'h939a3968;
    ram_cell[       3] = 32'h0;  // 32'h435c74bb;
    ram_cell[       4] = 32'h0;  // 32'h737a6dd8;
    ram_cell[       5] = 32'h0;  // 32'h938ac5c6;
    ram_cell[       6] = 32'h0;  // 32'h72fd5889;
    ram_cell[       7] = 32'h0;  // 32'hff9e56d7;
    ram_cell[       8] = 32'h0;  // 32'h5d0f965a;
    ram_cell[       9] = 32'h0;  // 32'h4537190a;
    ram_cell[      10] = 32'h0;  // 32'hbc6a04c6;
    ram_cell[      11] = 32'h0;  // 32'h52c83e44;
    ram_cell[      12] = 32'h0;  // 32'h738aae51;
    ram_cell[      13] = 32'h0;  // 32'h15919c6e;
    ram_cell[      14] = 32'h0;  // 32'h077c755f;
    ram_cell[      15] = 32'h0;  // 32'h1f6b6cbe;
    ram_cell[      16] = 32'h0;  // 32'h163679e5;
    ram_cell[      17] = 32'h0;  // 32'h14bb6b7e;
    ram_cell[      18] = 32'h0;  // 32'h727d9a93;
    ram_cell[      19] = 32'h0;  // 32'h22117d27;
    ram_cell[      20] = 32'h0;  // 32'h1b6a7be2;
    ram_cell[      21] = 32'h0;  // 32'h32cebc85;
    ram_cell[      22] = 32'h0;  // 32'hfca8ff8a;
    ram_cell[      23] = 32'h0;  // 32'h83d3b25c;
    ram_cell[      24] = 32'h0;  // 32'h8f121c4a;
    ram_cell[      25] = 32'h0;  // 32'h546d843b;
    ram_cell[      26] = 32'h0;  // 32'h032cda37;
    ram_cell[      27] = 32'h0;  // 32'h7a881c2d;
    ram_cell[      28] = 32'h0;  // 32'ha56bc2da;
    ram_cell[      29] = 32'h0;  // 32'h0a4fabbb;
    ram_cell[      30] = 32'h0;  // 32'h54828399;
    ram_cell[      31] = 32'h0;  // 32'he1969b21;
    ram_cell[      32] = 32'h0;  // 32'h4c215d93;
    ram_cell[      33] = 32'h0;  // 32'h950bc65d;
    ram_cell[      34] = 32'h0;  // 32'hc4df6c74;
    ram_cell[      35] = 32'h0;  // 32'hd519a618;
    ram_cell[      36] = 32'h0;  // 32'h7195809b;
    ram_cell[      37] = 32'h0;  // 32'h67d654bd;
    ram_cell[      38] = 32'h0;  // 32'h76dbfa77;
    ram_cell[      39] = 32'h0;  // 32'hea6558f7;
    ram_cell[      40] = 32'h0;  // 32'h01db0082;
    ram_cell[      41] = 32'h0;  // 32'h7c458755;
    ram_cell[      42] = 32'h0;  // 32'hf0560d38;
    ram_cell[      43] = 32'h0;  // 32'hb80167fb;
    ram_cell[      44] = 32'h0;  // 32'h47c44355;
    ram_cell[      45] = 32'h0;  // 32'h7ad61664;
    ram_cell[      46] = 32'h0;  // 32'h4c03e5aa;
    ram_cell[      47] = 32'h0;  // 32'hcc91331f;
    ram_cell[      48] = 32'h0;  // 32'h4c46332f;
    ram_cell[      49] = 32'h0;  // 32'hc44c1014;
    ram_cell[      50] = 32'h0;  // 32'hf754acf8;
    ram_cell[      51] = 32'h0;  // 32'h1b50de26;
    ram_cell[      52] = 32'h0;  // 32'he74dc103;
    ram_cell[      53] = 32'h0;  // 32'h90c3e7c8;
    ram_cell[      54] = 32'h0;  // 32'hae3e7cc3;
    ram_cell[      55] = 32'h0;  // 32'h527057c3;
    ram_cell[      56] = 32'h0;  // 32'he0200247;
    ram_cell[      57] = 32'h0;  // 32'hf9eb0938;
    ram_cell[      58] = 32'h0;  // 32'h87412d8b;
    ram_cell[      59] = 32'h0;  // 32'h6fc11571;
    ram_cell[      60] = 32'h0;  // 32'h502892ae;
    ram_cell[      61] = 32'h0;  // 32'hdef78a3f;
    ram_cell[      62] = 32'h0;  // 32'hf0ba625a;
    ram_cell[      63] = 32'h0;  // 32'h444ba70c;
    // src matrix A
    ram_cell[      64] = 32'h417c8b89;
    ram_cell[      65] = 32'h88daac78;
    ram_cell[      66] = 32'h9a24bf49;
    ram_cell[      67] = 32'hd4236f64;
    ram_cell[      68] = 32'h0d9396be;
    ram_cell[      69] = 32'h847d33df;
    ram_cell[      70] = 32'hcab4af00;
    ram_cell[      71] = 32'hb41cb7f9;
    ram_cell[      72] = 32'h911dfbc2;
    ram_cell[      73] = 32'h19d5a0ea;
    ram_cell[      74] = 32'h6d5b47e6;
    ram_cell[      75] = 32'hd2a5bf6d;
    ram_cell[      76] = 32'hff2fe5cc;
    ram_cell[      77] = 32'h645b9b6c;
    ram_cell[      78] = 32'hba7e5739;
    ram_cell[      79] = 32'hc359956b;
    ram_cell[      80] = 32'hd3d30d3c;
    ram_cell[      81] = 32'h014d64ce;
    ram_cell[      82] = 32'h1645eb36;
    ram_cell[      83] = 32'hd0c66477;
    ram_cell[      84] = 32'h6de9a93d;
    ram_cell[      85] = 32'hf639390a;
    ram_cell[      86] = 32'hd1b22c40;
    ram_cell[      87] = 32'h14d1bd46;
    ram_cell[      88] = 32'hd7190981;
    ram_cell[      89] = 32'h0e64b2e6;
    ram_cell[      90] = 32'h878ce584;
    ram_cell[      91] = 32'h82767ae8;
    ram_cell[      92] = 32'h90b5bde6;
    ram_cell[      93] = 32'hc9c9d85e;
    ram_cell[      94] = 32'hc67abc52;
    ram_cell[      95] = 32'hb01e8903;
    ram_cell[      96] = 32'hfa4e74d5;
    ram_cell[      97] = 32'h33e09fbf;
    ram_cell[      98] = 32'h5f1c3c64;
    ram_cell[      99] = 32'hc1ae35eb;
    ram_cell[     100] = 32'h22c5d519;
    ram_cell[     101] = 32'hcf46464f;
    ram_cell[     102] = 32'h5bc416ae;
    ram_cell[     103] = 32'h07e7db31;
    ram_cell[     104] = 32'ha78686a0;
    ram_cell[     105] = 32'hefde010b;
    ram_cell[     106] = 32'ha629ea68;
    ram_cell[     107] = 32'h37130d1c;
    ram_cell[     108] = 32'heb59fc29;
    ram_cell[     109] = 32'hba3926c2;
    ram_cell[     110] = 32'h6a20f340;
    ram_cell[     111] = 32'h3f5abf0a;
    ram_cell[     112] = 32'heb6b1ea4;
    ram_cell[     113] = 32'h1a3270c9;
    ram_cell[     114] = 32'h9bcd4b82;
    ram_cell[     115] = 32'hc15f2ac1;
    ram_cell[     116] = 32'h8ba32747;
    ram_cell[     117] = 32'h8e0d8706;
    ram_cell[     118] = 32'hd3221d71;
    ram_cell[     119] = 32'h5987815c;
    ram_cell[     120] = 32'hfb300e45;
    ram_cell[     121] = 32'h8338aa4a;
    ram_cell[     122] = 32'h97faf7be;
    ram_cell[     123] = 32'h7b3d82ec;
    ram_cell[     124] = 32'h3dd4529d;
    ram_cell[     125] = 32'h82a3f488;
    ram_cell[     126] = 32'h241fd808;
    ram_cell[     127] = 32'h60fd18aa;
    // src matrix B
    ram_cell[     128] = 32'h31031f0f;
    ram_cell[     129] = 32'h80209530;
    ram_cell[     130] = 32'h26a1c79f;
    ram_cell[     131] = 32'h9f2f6322;
    ram_cell[     132] = 32'hf9eb413f;
    ram_cell[     133] = 32'h81d6fbe7;
    ram_cell[     134] = 32'h53638503;
    ram_cell[     135] = 32'h4bc23fdb;
    ram_cell[     136] = 32'h584dcd2e;
    ram_cell[     137] = 32'hfa8b84b9;
    ram_cell[     138] = 32'h2f30dfd4;
    ram_cell[     139] = 32'h505ece04;
    ram_cell[     140] = 32'h7268c44e;
    ram_cell[     141] = 32'h0eaa9aca;
    ram_cell[     142] = 32'h14963cdb;
    ram_cell[     143] = 32'h166b1486;
    ram_cell[     144] = 32'hddf0bf32;
    ram_cell[     145] = 32'h13df6326;
    ram_cell[     146] = 32'h7da8de7d;
    ram_cell[     147] = 32'h09cbce16;
    ram_cell[     148] = 32'hb0b270c5;
    ram_cell[     149] = 32'h8a4202d2;
    ram_cell[     150] = 32'hc1e220d7;
    ram_cell[     151] = 32'h14eb5a42;
    ram_cell[     152] = 32'hf9f534cd;
    ram_cell[     153] = 32'h37f8f2c8;
    ram_cell[     154] = 32'h53ee1467;
    ram_cell[     155] = 32'hdd9c2d52;
    ram_cell[     156] = 32'he43c5721;
    ram_cell[     157] = 32'h0b31629b;
    ram_cell[     158] = 32'h027c84cf;
    ram_cell[     159] = 32'hff3a6b2b;
    ram_cell[     160] = 32'h1abe2412;
    ram_cell[     161] = 32'h0c4d9b52;
    ram_cell[     162] = 32'h94790354;
    ram_cell[     163] = 32'h595cee9b;
    ram_cell[     164] = 32'h22fd3ba9;
    ram_cell[     165] = 32'h4b550824;
    ram_cell[     166] = 32'hd8b9ec5d;
    ram_cell[     167] = 32'h2585298d;
    ram_cell[     168] = 32'hfae9bc46;
    ram_cell[     169] = 32'he4008ceb;
    ram_cell[     170] = 32'he4fb7746;
    ram_cell[     171] = 32'h15068390;
    ram_cell[     172] = 32'h06643eed;
    ram_cell[     173] = 32'h84e59209;
    ram_cell[     174] = 32'he8a6e507;
    ram_cell[     175] = 32'h50a23e1a;
    ram_cell[     176] = 32'h1ec40210;
    ram_cell[     177] = 32'had520f6d;
    ram_cell[     178] = 32'h3f9f612f;
    ram_cell[     179] = 32'h78fe00f5;
    ram_cell[     180] = 32'h49cc748d;
    ram_cell[     181] = 32'hf71255cb;
    ram_cell[     182] = 32'ha8537dec;
    ram_cell[     183] = 32'hd16e0e73;
    ram_cell[     184] = 32'h95ba416b;
    ram_cell[     185] = 32'h885941a7;
    ram_cell[     186] = 32'hd909308a;
    ram_cell[     187] = 32'h5a2fe053;
    ram_cell[     188] = 32'hd3f14fb3;
    ram_cell[     189] = 32'hb8463696;
    ram_cell[     190] = 32'hea25bc8c;
    ram_cell[     191] = 32'h56cdc94a;
end

endmodule

