#include <iostream>
#include <inttypes.h>
#include <algorithm>
#include "fr.cuh"
#include "twiddle_f.cuh"
#include "../parameter/parameter.cuh"

uint32_t ONE[h_NUM] = {1,0,0,0,0,0,0,0};
uint32_t OMEGA[30][h_NUM] = 
{{1,0,0,0,0,0,0,0},
{0xf02592a6, 0x677742a6, 0x0b0bcfdc, 0xdda37d9b, 0x3a5ff847, 0xa8fbe1eb, 0xbc8f55ce, 0xf14b6fd },
{0x80430bb6, 0x8ffb1c1b, 0xeb512699, 0x86df557a, 0x3d9da2d2, 0xa107daf1, 0xf1d91078, 0x22cbb965 },
{0x2b3100ac, 0x770f412a, 0x5ebeabb2, 0xfe0d13ca, 0x32fbad3a, 0xe25896a6, 0xc523d7ba, 0x24e1aa27 },
{0x51c86725, 0xb64e6cc0, 0x2b100b69, 0x5d2954e8, 0x0f9f7285, 0xea6a52ef, 0x249426b1, 0x157b33f2 },
{0x708aa1e7, 0x534c23d4, 0x848731bd, 0x6df241c4, 0x487e9d0e, 0x6956ab5a, 0x2708b270, 0x21b9bb85 },
{0x4df1ef18, 0x36209c7c, 0x4b06e314, 0x88eaee7e, 0xc682364c, 0xdb63ea13, 0xb3547d0d, 0x1f7f2237 },
{0xa3fe73ec, 0x3232d861, 0x4d3d29b6, 0x8e998cce, 0xe408d4b5, 0x4498ced3, 0x4e1303ed, 0x130e6907 },
{0x7961aefa, 0x7afb685f, 0x199d0b9e, 0xe6048d1c, 0x8d850ff4, 0x851801a4, 0x2000b9d6, 0x3aa0e6 },
{0x5cc0d985, 0x4f4058ff, 0x83a2cb1b, 0xfd65200d, 0x78c3ad26, 0x4881a3f4, 0xa802a642, 0xa69f3ad },
{0xed06047d, 0xc9ea9467, 0x7a89d2d0, 0x0051c62c, 0xedce5796, 0x88a0912e, 0x791f5fa0, 0x1a56a55d },
{0x9bc22337, 0xdfdbb8be, 0x2b9c9807, 0x9b563b3a, 0x2bef18d5, 0x5d71312d, 0x839d9061, 0x1102db9a },
{0x244a0dcf, 0x22c2cb7e, 0xed6faaac, 0xd9ab2b9e, 0xea442ba8, 0xe80681ee, 0x81e5b3aa, 0x26870242 },
{0x5ddad6c8, 0xd8224f6a, 0xb3a6811d, 0x1ff0ffbb, 0x512e020a, 0x0d029d0b, 0x91c48cca, 0x12a369e1 },
{0x95f3cab1, 0x3254290c, 0xbb7ceab3, 0x0064dd23, 0xc5d58a6c, 0xebb14371, 0x5f333a70, 0x1093e6ad },
{0xdcabfa03, 0xcc70a4e1, 0xa50fe004, 0xfbd69ddf, 0x09269585, 0xd161c854, 0xbb063c37, 0x211ffeb7 },
{0xa0ca59bb, 0xdd74ce59, 0x12854381, 0x9872ac6e, 0xc4bd3958, 0x465242bb, 0x4eb42f91, 0x22e45c2a },
{0xc4a6cb2c, 0x71886146, 0x1b3d20ec, 0xb7c8c985, 0x6c988abf, 0x052a31d1, 0xea5ed7ba, 0x72d1cc7 },
{0xc8db7408, 0x2ad7ceac, 0x8b6156d1, 0x46ca4d0f, 0x8b527b58, 0xd1b5f0c6, 0xd618c4f9, 0x247e0e6c },
{0x81f8ede0, 0x9dcee020, 0x1780dd86, 0x4660eca9, 0xb02d0991, 0x69083a52, 0x83d05718, 0x2306778f },
{0x3f6edde7, 0x3713541c, 0x3dff862b, 0x1325398f, 0x7132ff6b, 0x386b7e9d, 0xc919f3f4, 0x1d2c5a17 },
{0x55123434, 0xb4a0ced5, 0xc9f4db3b, 0xf257ae2b, 0x49acab98, 0x6d75f8f9, 0xe65ccc2c, 0x2ba9eb33 },
{0x481bb746, 0x39912173, 0x6f6b2757, 0x5e85e3ad, 0x6980721d, 0xb5104e2f, 0x333d69f6, 0x1691e671 },
{0xab1d7dfa, 0x6809491f, 0xa31dbd29, 0x9f5c22de, 0x799af88c, 0xe08dcd7f, 0xab3327c8, 0xb4b4c22 },
{0xbe85bd82, 0x2298dc6a, 0xc0541d73, 0x02a272ee, 0x8e1b6445, 0xbd014689, 0x6ff963c1, 0x39665da },
{0x21c418ee, 0x6dd0a1e0, 0xb8d2ed55, 0x7d06fd06, 0x06e31759, 0x86213109, 0x9f420d75, 0x7f1c0f6 },
{0x95465bb4, 0xa4ecccd0, 0xc7e22a09, 0x0a37a1ab, 0x4826fe1e, 0x229c712d, 0x5f5aa806, 0x16d45b18 },
{0xd308947e, 0xc9c4c5a6, 0xee451bad, 0x3cf2a3c6, 0x7df7a178, 0x75ceeb59, 0x8c206520, 0x27a0fec1 },
{0xf8aa7285, 0xc2da746c, 0x98d08e70, 0x6f925403, 0x8c21ef42, 0xe061daa6, 0xeaa3315c, 0x19e60cab },
{0xac604e67, 0x93b48513, 0xff747f0f, 0x1efcd802, 0xf8122729, 0x6aff5b31, 0x29116cfd, 0x2bca8885 }};


__noinline__ void OmegaTable(uint32_t* OmegaTable, uint32_t LOGN_max){ //There are only N-1 values in the table, and space for N values is allocated for convenience
    uint32_t w[h_NUM];
    uint32_t w_m[h_NUM];
    int a = 0;
    for (int i = 1; i <= LOGN_max; i++){
        copy(OMEGA[i], OMEGA[i]+h_NUM, w_m);
        copy(ONE, ONE+h_NUM, w);
        for(int j = 0; j < 1<<(i-1); j++){
            copy(w, w+h_NUM, OmegaTable+a*h_NUM);
            a++;
            h_MUL(w, w_m, w);
        }
    }
}

__noinline__ void OmegaTableStep2(uint32_t* OmegaTableStep2, uint32_t ROW, uint32_t COL, uint32_t RC_SUM){
    uint32_t w[h_NUM];
    uint32_t w_i[h_NUM];
    copy(ONE, ONE+h_NUM, w_i);
    for (int i = 0; i < COL; i++){
        copy(ONE, ONE+h_NUM, w);
        for (int j = 0; j < ROW; j++){
            copy(w, w+h_NUM, OmegaTableStep2+(i*ROW+j)*h_NUM);
            h_MUL(w, w_i, w);
        }
        h_MUL(w_i, OMEGA[RC_SUM], w_i);
    }
}