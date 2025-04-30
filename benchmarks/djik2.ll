define dso_local noundef i32 @sfe_main(ptr noundef %a, ptr noundef %b, i32 noundef %l1, i32 noundef %l2) {
entry:
  %a.addr = alloca ptr, align 8
  %b.addr = alloca ptr, align 8
  %l1.addr = alloca i32, align 4
  %l2.addr = alloca i32, align 4
  %vis = alloca [40 x i32], align 16
  %dis = alloca [40 x i32], align 16
  %e = alloca ptr, align 8
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %bestj = alloca i32, align 4
  %bestdis = alloca i32, align 4
  %j = alloca i32, align 4
  %j15 = alloca i32, align 4
  %newDis = alloca i32, align 4
  store ptr %a, ptr %a.addr, align 8
  store ptr %b, ptr %b.addr, align 8
  store i32 %l1, ptr %l1.addr, align 4
  store i32 %l2, ptr %l2.addr, align 4
  %0 = load ptr, ptr %b.addr, align 8
  %arrayidx = getelementptr inbounds i32, ptr %0, i64 0
  %1 = load i32, ptr %arrayidx, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx1 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom
  store i32 0, ptr %arrayidx1, align 4
  %2 = load ptr, ptr %a.addr, align 8
  %add.ptr = getelementptr inbounds i32, ptr %2, i64 1
  store ptr %add.ptr, ptr %e, align 8
  %3 = load ptr, ptr %a.addr, align 8
  %arrayidx2 = getelementptr inbounds i32, ptr %3, i64 0
  %4 = load i32, ptr %arrayidx2, align 4
  store i32 %4, ptr %n, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:
  %5 = load i32, ptr %i, align 4
  %6 = load i32, ptr %n, align 4
  %cmp = icmp slt i32 %5, %6
  br i1 %cmp, label %for.body, label %for.end34

for.body:
  store i32 -1, ptr %bestj, align 4
  store i32 -1, ptr %bestdis, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond3

for.cond3:
  %7 = load i32, ptr %j, align 4
  %8 = load i32, ptr %n, align 4
  %cmp4 = icmp slt i32 %7, %8
  br i1 %cmp4, label %for.body5, label %for.end

for.body5:
  %9 = load i32, ptr %j, align 4
  %idxprom6 = sext i32 %9 to i64
  %arrayidx7 = getelementptr inbounds [40 x i32], ptr %vis, i64 0, i64 %idxprom6
  %10 = load i32, ptr %arrayidx7, align 4
  %tobool = icmp ne i32 %10, 0
  br i1 %tobool, label %if.end, label %land.lhs.true

land.lhs.true:
  %11 = load i32, ptr %j, align 4
  %idxprom8 = sext i32 %11 to i64
  %arrayidx9 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom8
  %12 = load i32, ptr %arrayidx9, align 4
  %13 = load i32, ptr %bestdis, align 4
  %cmp10 = icmp slt i32 %12, %13
  br i1 %cmp10, label %if.then, label %if.end

if.then:
  %14 = load i32, ptr %j, align 4
  store i32 %14, ptr %bestj, align 4
  %15 = load i32, ptr %j, align 4
  %idxprom11 = sext i32 %15 to i64
  %arrayidx12 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom11
  %16 = load i32, ptr %arrayidx12, align 4
  store i32 %16, ptr %bestdis, align 4
  br label %if.end

if.end:
  br label %for.inc

for.inc:
  %17 = load i32, ptr %j, align 4
  %inc = add nsw i32 %17, 1
  store i32 %inc, ptr %j, align 4
  br label %for.cond3

for.end:
  %18 = load i32, ptr %bestj, align 4
  %idxprom13 = sext i32 %18 to i64
  %arrayidx14 = getelementptr inbounds [40 x i32], ptr %vis, i64 0, i64 %idxprom13
  store i32 1, ptr %arrayidx14, align 4
  store i32 0, ptr %j15, align 4
  br label %for.cond16

for.cond16:
  %19 = load i32, ptr %j15, align 4
  %20 = load i32, ptr %n, align 4
  %cmp17 = icmp slt i32 %19, %20
  br i1 %cmp17, label %for.body18, label %for.end31

for.body18:
  %21 = load i32, ptr %bestdis, align 4
  %22 = load ptr, ptr %e, align 8
  %23 = load i32, ptr %bestj, align 4
  %24 = load i32, ptr %n, align 4
  %mul = mul nsw i32 %23, %24
  %25 = load i32, ptr %j15, align 4
  %add = add nsw i32 %mul, %25
  %idxprom19 = sext i32 %add to i64
  %arrayidx20 = getelementptr inbounds i32, ptr %22, i64 %idxprom19
  %26 = load i32, ptr %arrayidx20, align 4
  %add21 = add nsw i32 %21, %26
  store i32 %add21, ptr %newDis, align 4
  %27 = load i32, ptr %newDis, align 4
  %28 = load i32, ptr %j15, align 4
  %idxprom22 = sext i32 %28 to i64
  %arrayidx23 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom22
  %29 = load i32, ptr %arrayidx23, align 4
  %cmp24 = icmp slt i32 %27, %29
  br i1 %cmp24, label %if.then25, label %if.end28

if.then25:
  %30 = load i32, ptr %newDis, align 4
  %31 = load i32, ptr %j15, align 4
  %idxprom26 = sext i32 %31 to i64
  %arrayidx27 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom26
  store i32 %30, ptr %arrayidx27, align 4
  br label %if.end28

if.end28:
  br label %for.inc29

for.inc29:
  %32 = load i32, ptr %j15, align 4
  %inc30 = add nsw i32 %32, 1
  store i32 %inc30, ptr %j15, align 4
  br label %for.cond16

for.end31:
  br label %for.inc32

for.inc32:
  %33 = load i32, ptr %i, align 4
  %inc33 = add nsw i32 %33, 1
  store i32 %inc33, ptr %i, align 4
  br label %for.cond

for.end34:
  %34 = load ptr, ptr %b.addr, align 8
  %arrayidx35 = getelementptr inbounds i32, ptr %34, i64 1
  %35 = load i32, ptr %arrayidx35, align 4
  %idxprom36 = sext i32 %35 to i64
  %arrayidx37 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom36
  %36 = load i32, ptr %arrayidx37, align 4
  ret i32 %36
}