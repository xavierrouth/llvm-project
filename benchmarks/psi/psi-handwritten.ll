target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @main() {
entry:
  %M = alloca i32, i32 2048

  ;–– jump into the loop ––
  br label %loop

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
loop:                                     ; preds = %entry, %loop
  ;–– φ nodes for  “registers” ––
  %r0 = phi i32 [  0, %entry ], [ %new_r0, %loop ]
  %r1 = phi i32 [ 64, %entry ], [ %new_r1, %loop ]
  %r2 = phi i32 [  0, %entry ], [ %new_r2, %loop ]

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 1) LOAD %GR3, %GR0 ––
  %ptr3 = getelementptr inbounds i32, i32* %M, i32 %r0
  %r3    = load            i32, i32* %ptr3

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 2) LOAD %GR4, %GR1 ––
  %ptr4 = getelementptr inbounds i32, i32* %M, i32 %r1
  %r4    = load            i32, i32* %ptr4

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 3) CMP+RS1 for (r3 vs. r4): tar = ashr(2·(r3<u r4)+(r3<s r4), 1) ––
  %u_lt1 = icmp ult i32 %r3, %r4
  %s_lt1 = icmp slt i32 %r3, %r4
  %u_i1   = zext   i1  %u_lt1 to i32
  %two1   = shl    i32 %u_i1, 1
  %s_i1   = zext   i1  %s_lt1 to i32
  %cmp1   = add    i32 %two1, %s_i1
  %off1   = ashr   i32 %cmp1, 1

  ;–– 4) ADD %GR0, %GR0, %off1 ––
  %tmp0   = add    i32 %r0, %off1

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 5) CMP+RS1 for (r4 vs. r3): tar = ashr(2·(r4<u r3)+(r4<s r3), 1) ––
  %u_lt2 = icmp ult i32 %r4, %r3
  %s_lt2 = icmp slt i32 %r4, %r3
  %u_i2   = zext   i1  %u_lt2 to i32
  %two2   = shl    i32 %u_i2, 1
  %s_i2   = zext   i1  %s_lt2 to i32
  %cmp2   = add    i32 %two2, %s_i2
  %off2   = ashr   i32 %cmp2, 1

  ;–– 6) ADD %GR1, %GR1, %off2 ––
  %new_r1 = add    i32 %r1, %off2

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 7) EQ %GR5, %GR3, %GR4 → flag = (r3==r4)?1:0 ––
  %eql    = icmp eq i32 %r3, %r4
  %flag   = zext   i1  %eql  to i32

  ;–– 8) ADD %GR0, tmp0, flag ––
  %new_r0 = add    i32 %tmp0,   %flag

  ;–– 9) ADD %GR2, %GR2, flag ––  (accumulate)
  %new_r2 = add    i32 %r2,     %flag

  ;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  ;–– 10) Exit test: 
  ;      EQI %GR5, %new_r0,  64
  ;      EQI %GR6, %new_r1, 128
  ;      XOR %GR5, %GR5, %GR6
  %e0   = icmp eq i32 %new_r0,  64
  %e1   = icmp eq i32 %new_r1, 128
  %cond = xor    i1  %e0,      %e1

  ;–– JNE: branch back if cond==0, otherwise fall through ––
  br i1 %cond, label %end, label %loop

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
end:
  ret void
}