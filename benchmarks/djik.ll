define dso_local noundef i32 @sfe_main(ptr noundef readonly captures(none) %a, ptr noundef readonly captures(none) %b, i32 noundef %l1, i32 noundef %l2) local_unnamed_addr {
entry:
  %vis = alloca [40 x i32], align 16
  %dis = alloca [40 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 160, ptr nonnull %vis) #4
  call void @llvm.lifetime.start.p0(i64 160, ptr nonnull %dis) #4
  %0 = load i32, ptr %b, align 4
  %idxprom = sext i32 %0 to i64
  %arrayidx1 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom
  store i32 0, ptr %arrayidx1, align 4
  %add.ptr = getelementptr inbounds nuw i8, ptr %a, i64 4
  %1 = load i32, ptr %a, align 4
  %cmp67 = icmp sgt i32 %1, 0
  br i1 %cmp67, label %for.cond3.preheader.us.us.preheader, label %for.cond.cleanup

for.cond3.preheader.us.us.preheader:
  %wide.trip.count = zext nneg i32 %1 to i64
  %xtraiter = and i64 %wide.trip.count, 1
  %2 = icmp eq i32 %1, 1
  %unroll_iter = and i64 %wide.trip.count, 2147483646
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  %min.iters.check = icmp ult i32 %1, 8
  %n.vec = and i64 %wide.trip.count, 2147483640
  %cmp.n = icmp eq i64 %n.vec, %wide.trip.count
  br label %for.cond3.preheader.us.us

for.cond3.preheader.us.us:
  %i.068.us.us = phi i32 [ %inc35.us.us, %for.cond17.for.cond.cleanup19_crit_edge.us.us ], [ 0, %for.cond3.preheader.us.us.preheader ]
  br i1 %2, label %for.cond3.for.cond.cleanup5_crit_edge.us.us.unr-lcssa, label %for.body6.us.us

for.body20.us.us:
  %indvars.iv98 = phi i64 [ %indvars.iv.next99, %for.body20.us.us ], [ %indvars.iv98.ph, %for.body20.us.us.preheader ]
  %gep = getelementptr i32, ptr %invariant.gep, i64 %indvars.iv98
  %3 = load i32, ptr %gep, align 4
  %add23.us.us = add nsw i32 %3, %bestdis.1.us.us.lcssa
  %arrayidx25.us.us = getelementptr inbounds nuw [40 x i32], ptr %dis, i64 0, i64 %indvars.iv98
  %4 = load i32, ptr %arrayidx25.us.us, align 4
  %spec.store.select.us.us = tail call i32 @llvm.smin.i32(i32 %add23.us.us, i32 %4)
  store i32 %spec.store.select.us.us, ptr %arrayidx25.us.us, align 4
  %indvars.iv.next99 = add nuw nsw i64 %indvars.iv98, 1
  %exitcond103.not = icmp eq i64 %indvars.iv.next99, %wide.trip.count
  br i1 %exitcond103.not, label %for.cond17.for.cond.cleanup19_crit_edge.us.us, label %for.body20.us.us

for.body6.us.us:
  %indvars.iv = phi i64 [ %indvars.iv.next.1, %for.inc.us.us.1 ], [ 0, %for.cond3.preheader.us.us ]
  %bestdis.062.us.us = phi i32 [ %bestdis.1.us.us.1, %for.inc.us.us.1 ], [ -1, %for.cond3.preheader.us.us ]
  %bestj.061.us.us = phi i32 [ %bestj.1.us.us.1, %for.inc.us.us.1 ], [ -1, %for.cond3.preheader.us.us ]
  %niter = phi i64 [ %niter.next.1, %for.inc.us.us.1 ], [ 0, %for.cond3.preheader.us.us ]
  %arrayidx8.us.us = getelementptr inbounds nuw [40 x i32], ptr %vis, i64 0, i64 %indvars.iv
  %5 = load i32, ptr %arrayidx8.us.us, align 8
  %tobool.not.us.us = icmp eq i32 %5, 0
  br i1 %tobool.not.us.us, label %land.lhs.true.us.us, label %for.inc.us.us

land.lhs.true.us.us:
  %arrayidx10.us.us = getelementptr inbounds nuw [40 x i32], ptr %dis, i64 0, i64 %indvars.iv
  %6 = load i32, ptr %arrayidx10.us.us, align 8
  %cmp11.us.us = icmp slt i32 %6, %bestdis.062.us.us
  %7 = trunc nuw nsw i64 %indvars.iv to i32
  %spec.select.us.us = select i1 %cmp11.us.us, i32 %7, i32 %bestj.061.us.us
  %spec.select59.us.us = tail call i32 @llvm.smin.i32(i32 %6, i32 %bestdis.062.us.us)
  br label %for.inc.us.us

for.inc.us.us:
  %bestj.1.us.us = phi i32 [ %bestj.061.us.us, %for.body6.us.us ], [ %spec.select.us.us, %land.lhs.true.us.us ]
  %bestdis.1.us.us = phi i32 [ %bestdis.062.us.us, %for.body6.us.us ], [ %spec.select59.us.us, %land.lhs.true.us.us ]
  %indvars.iv.next = or disjoint i64 %indvars.iv, 1
  %arrayidx8.us.us.1 = getelementptr inbounds nuw [40 x i32], ptr %vis, i64 0, i64 %indvars.iv.next
  %8 = load i32, ptr %arrayidx8.us.us.1, align 4
  %tobool.not.us.us.1 = icmp eq i32 %8, 0
  br i1 %tobool.not.us.us.1, label %land.lhs.true.us.us.1, label %for.inc.us.us.1

land.lhs.true.us.us.1:
  %arrayidx10.us.us.1 = getelementptr inbounds nuw [40 x i32], ptr %dis, i64 0, i64 %indvars.iv.next
  %9 = load i32, ptr %arrayidx10.us.us.1, align 4
  %cmp11.us.us.1 = icmp slt i32 %9, %bestdis.1.us.us
  %10 = trunc nuw nsw i64 %indvars.iv.next to i32
  %spec.select.us.us.1 = select i1 %cmp11.us.us.1, i32 %10, i32 %bestj.1.us.us
  %spec.select59.us.us.1 = tail call i32 @llvm.smin.i32(i32 %9, i32 %bestdis.1.us.us)
  br label %for.inc.us.us.1

for.inc.us.us.1:
  %bestj.1.us.us.1 = phi i32 [ %bestj.1.us.us, %for.inc.us.us ], [ %spec.select.us.us.1, %land.lhs.true.us.us.1 ]
  %bestdis.1.us.us.1 = phi i32 [ %bestdis.1.us.us, %for.inc.us.us ], [ %spec.select59.us.us.1, %land.lhs.true.us.us.1 ]
  %indvars.iv.next.1 = add nuw nsw i64 %indvars.iv, 2
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1, label %for.cond3.for.cond.cleanup5_crit_edge.us.us.unr-lcssa, label %for.body6.us.us

for.cond3.for.cond.cleanup5_crit_edge.us.us.unr-lcssa:
  %bestj.1.us.us.lcssa.ph = phi i32 [ poison, %for.cond3.preheader.us.us ], [ %bestj.1.us.us.1, %for.inc.us.us.1 ]
  %bestdis.1.us.us.lcssa.ph = phi i32 [ poison, %for.cond3.preheader.us.us ], [ %bestdis.1.us.us.1, %for.inc.us.us.1 ]
  %indvars.iv.unr = phi i64 [ 0, %for.cond3.preheader.us.us ], [ %indvars.iv.next.1, %for.inc.us.us.1 ]
  %bestdis.062.us.us.unr = phi i32 [ -1, %for.cond3.preheader.us.us ], [ %bestdis.1.us.us.1, %for.inc.us.us.1 ]
  %bestj.061.us.us.unr = phi i32 [ -1, %for.cond3.preheader.us.us ], [ %bestj.1.us.us.1, %for.inc.us.us.1 ]
  br i1 %lcmp.mod.not, label %for.cond3.for.cond.cleanup5_crit_edge.us.us, label %for.body6.us.us.epil

for.body6.us.us.epil:
  %arrayidx8.us.us.epil = getelementptr inbounds nuw [40 x i32], ptr %vis, i64 0, i64 %indvars.iv.unr
  %11 = load i32, ptr %arrayidx8.us.us.epil, align 4
  %tobool.not.us.us.epil = icmp eq i32 %11, 0
  br i1 %tobool.not.us.us.epil, label %land.lhs.true.us.us.epil, label %for.cond3.for.cond.cleanup5_crit_edge.us.us

land.lhs.true.us.us.epil:
  %arrayidx10.us.us.epil = getelementptr inbounds nuw [40 x i32], ptr %dis, i64 0, i64 %indvars.iv.unr
  %12 = load i32, ptr %arrayidx10.us.us.epil, align 4
  %cmp11.us.us.epil = icmp slt i32 %12, %bestdis.062.us.us.unr
  %13 = trunc nuw nsw i64 %indvars.iv.unr to i32
  %spec.select.us.us.epil = select i1 %cmp11.us.us.epil, i32 %13, i32 %bestj.061.us.us.unr
  %spec.select59.us.us.epil = tail call i32 @llvm.smin.i32(i32 %12, i32 %bestdis.062.us.us.unr)
  br label %for.cond3.for.cond.cleanup5_crit_edge.us.us

for.cond3.for.cond.cleanup5_crit_edge.us.us:
  %bestj.1.us.us.lcssa = phi i32 [ %bestj.1.us.us.lcssa.ph, %for.cond3.for.cond.cleanup5_crit_edge.us.us.unr-lcssa ], [ %bestj.061.us.us.unr, %for.body6.us.us.epil ], [ %spec.select.us.us.epil, %land.lhs.true.us.us.epil ]
  %bestdis.1.us.us.lcssa = phi i32 [ %bestdis.1.us.us.lcssa.ph, %for.cond3.for.cond.cleanup5_crit_edge.us.us.unr-lcssa ], [ %bestdis.062.us.us.unr, %for.body6.us.us.epil ], [ %spec.select59.us.us.epil, %land.lhs.true.us.us.epil ]
  %idxprom14.us.us = sext i32 %bestj.1.us.us.lcssa to i64
  %arrayidx15.us.us = getelementptr inbounds [40 x i32], ptr %vis, i64 0, i64 %idxprom14.us.us
  store i32 1, ptr %arrayidx15.us.us, align 4
  %mul.us.us = mul nsw i32 %bestj.1.us.us.lcssa, %1
  %14 = sext i32 %mul.us.us to i64
  %invariant.gep = getelementptr i32, ptr %add.ptr, i64 %14
  br i1 %min.iters.check, label %for.body20.us.us.preheader, label %vector.ph

vector.ph:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %bestdis.1.us.us.lcssa, i64 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %15 = getelementptr i32, ptr %invariant.gep, i64 %index
  %16 = getelementptr i8, ptr %15, i64 16
  %wide.load = load <4 x i32>, ptr %15, align 4
  %wide.load105 = load <4 x i32>, ptr %16, align 4
  %17 = add nsw <4 x i32> %wide.load, %broadcast.splat
  %18 = add nsw <4 x i32> %wide.load105, %broadcast.splat
  %19 = getelementptr inbounds nuw [40 x i32], ptr %dis, i64 0, i64 %index
  %20 = getelementptr inbounds nuw i8, ptr %19, i64 16
  %wide.load106 = load <4 x i32>, ptr %19, align 16
  %wide.load107 = load <4 x i32>, ptr %20, align 16
  %21 = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %17, <4 x i32> %wide.load106)
  %22 = tail call <4 x i32> @llvm.smin.v4i32(<4 x i32> %18, <4 x i32> %wide.load107)
  store <4 x i32> %21, ptr %19, align 16
  store <4 x i32> %22, ptr %20, align 16
  %index.next = add nuw i64 %index, 8
  %23 = icmp eq i64 %index.next, %n.vec
  br i1 %23, label %middle.block, label %vector.body

middle.block:
  br i1 %cmp.n, label %for.cond17.for.cond.cleanup19_crit_edge.us.us, label %for.body20.us.us.preheader

for.body20.us.us.preheader:
  %indvars.iv98.ph = phi i64 [ 0, %for.cond3.for.cond.cleanup5_crit_edge.us.us ], [ %n.vec, %middle.block ]
  br label %for.body20.us.us

for.cond17.for.cond.cleanup19_crit_edge.us.us:
  %inc35.us.us = add nuw nsw i32 %i.068.us.us, 1
  %exitcond104.not = icmp eq i32 %inc35.us.us, %1
  br i1 %exitcond104.not, label %for.cond.cleanup, label %for.cond3.preheader.us.us

for.cond.cleanup:
  %arrayidx37 = getelementptr inbounds nuw i8, ptr %b, i64 4
  %24 = load i32, ptr %arrayidx37, align 4
  %idxprom38 = sext i32 %24 to i64
  %arrayidx39 = getelementptr inbounds [40 x i32], ptr %dis, i64 0, i64 %idxprom38
  %25 = load i32, ptr %arrayidx39, align 4
  call void @llvm.lifetime.end.p0(i64 160, ptr nonnull %dis) #4
  call void @llvm.lifetime.end.p0(i64 160, ptr nonnull %vis) #4
  ret i32 %25
}

declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

declare i32 @llvm.smin.i32(i32, i32) #3

declare <4 x i32> @llvm.smin.v4i32(<4 x i32>, <4 x i32>) #3

!41 = distinct !DIAssignID()
!43 = distinct !DIAssignID()