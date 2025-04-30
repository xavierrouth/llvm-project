define dso_local noundef i32 @sfe_main(ptr noundef readonly captures(none) %arr1, ptr noundef readonly captures(none) %arr2, i32 noundef %m, i32 noundef %n) local_unnamed_addr {
entry:
  %cmp27 = icmp sgt i32 %m, 0
  %cmp128 = icmp sgt i32 %n, 0
  %0 = and i1 %cmp27, %cmp128
  br i1 %0, label %while.body, label %while.end

while.body:
  %total.031 = phi i32 [ %total.1, %if.end15 ], [ 0, %entry ]
  %j.030 = phi i32 [ %j.1, %if.end15 ], [ 0, %entry ]
  %i.029 = phi i32 [ %i.1, %if.end15 ], [ 0, %entry ]
  %idxprom = sext i32 %i.029 to i64
  %arrayidx = getelementptr inbounds i32, ptr %arr1, i64 %idxprom
  %1 = load i32, ptr %arrayidx, align 4
  %idxprom2 = sext i32 %j.030 to i64
  %arrayidx3 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2
  %2 = load i32, ptr %arrayidx3, align 4
  %cmp4 = icmp slt i32 %1, %2
  br i1 %cmp4, label %if.then, label %if.else

if.then:
  %inc = add nsw i32 %i.029, 1
  br label %if.end15

if.else:
  %cmp9 = icmp slt i32 %2, %1
  br i1 %cmp9, label %if.then10, label %if.else12

if.then10:
  %inc11 = add nsw i32 %j.030, 1
  br label %if.end15

if.else12:
  %inc13 = add nsw i32 %i.029, 1
  %inc14 = add nsw i32 %total.031, 1
  br label %if.end15

if.end15:
  %i.1 = phi i32 [ %inc, %if.then ], [ %i.029, %if.then10 ], [ %inc13, %if.else12 ]
  %j.1 = phi i32 [ %j.030, %if.then ], [ %inc11, %if.then10 ], [ %j.030, %if.else12 ]
  %total.1 = phi i32 [ %total.031, %if.then ], [ %total.031, %if.then10 ], [ %inc14, %if.else12 ]
  %cmp = icmp slt i32 %i.1, %m
  %cmp1 = icmp slt i32 %j.1, %n
  %3 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %3, label %while.body, label %while.end

while.end:
  %total.0.lcssa = phi i32 [ 0, %entry ], [ %total.1, %if.end15 ]
  ret i32 %total.0.lcssa
}