target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local noundef i32 @sfe_main(ptr noundef %arr1, ptr noundef %arr2, i32 noundef %m, i32 noundef %n) {
entry:
  %arr1.addr = alloca ptr, align 8
  %arr2.addr = alloca ptr, align 8
  %m.addr = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %total = alloca i32, align 4
  store ptr %arr1, ptr %arr1.addr, align 8
  store ptr %arr2, ptr %arr2.addr, align 8
  store i32 %m, ptr %m.addr, align 4
  store i32 %n, ptr %n.addr, align 4
  store i32 0, ptr %i, align 4
  store i32 0, ptr %j, align 4
  store i32 0, ptr %total, align 4
  br label %while.cond

while.cond:
  %0 = load i32, ptr %i, align 4
  %1 = load i32, ptr %m.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %land.rhs, label %land.end

land.rhs:
  %2 = load i32, ptr %j, align 4
  %3 = load i32, ptr %n.addr, align 4
  %cmp1 = icmp slt i32 %2, %3
  br label %land.end

land.end:
  %4 = phi i1 [ false, %while.cond ], [ %cmp1, %land.rhs ]
  br i1 %4, label %while.body, label %while.end

while.body:
  %5 = load ptr, ptr %arr1.addr, align 8
  %6 = load i32, ptr %i, align 4
  %idxprom = sext i32 %6 to i64
  %arrayidx = getelementptr inbounds i32, ptr %5, i64 %idxprom
  %7 = load i32, ptr %arrayidx, align 4
  %8 = load ptr, ptr %arr2.addr, align 8
  %9 = load i32, ptr %j, align 4
  %idxprom2 = sext i32 %9 to i64
  %arrayidx3 = getelementptr inbounds i32, ptr %8, i64 %idxprom2
  %10 = load i32, ptr %arrayidx3, align 4
  %cmp4 = icmp slt i32 %7, %10
  br i1 %cmp4, label %if.then, label %if.else

if.then:
  %11 = load i32, ptr %i, align 4
  %inc = add nsw i32 %11, 1
  store i32 %inc, ptr %i, align 4
  br label %if.end15

if.else:
  %12 = load ptr, ptr %arr2.addr, align 8
  %13 = load i32, ptr %j, align 4
  %idxprom5 = sext i32 %13 to i64
  %arrayidx6 = getelementptr inbounds i32, ptr %12, i64 %idxprom5
  %14 = load i32, ptr %arrayidx6, align 4
  %15 = load ptr, ptr %arr1.addr, align 8
  %16 = load i32, ptr %i, align 4
  %idxprom7 = sext i32 %16 to i64
  %arrayidx8 = getelementptr inbounds i32, ptr %15, i64 %idxprom7
  %17 = load i32, ptr %arrayidx8, align 4
  %cmp9 = icmp slt i32 %14, %17
  br i1 %cmp9, label %if.then10, label %if.else12

if.then10:
  %18 = load i32, ptr %j, align 4
  %inc11 = add nsw i32 %18, 1
  store i32 %inc11, ptr %j, align 4
  br label %if.end

if.else12:
  %19 = load i32, ptr %i, align 4
  %inc13 = add nsw i32 %19, 1
  store i32 %inc13, ptr %i, align 4
  %20 = load i32, ptr %total, align 4
  %inc14 = add nsw i32 %20, 1
  store i32 %inc14, ptr %total, align 4
  br label %if.end

if.end:
  br label %if.end15

if.end15:
  br label %while.cond

while.end:
  %21 = load i32, ptr %total, align 4
  ret i32 %21
}