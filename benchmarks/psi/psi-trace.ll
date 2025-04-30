; ModuleID = '/workspaces/llvm-project/benchmarks/psi/psi.ll'
source_filename = "psi.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@0 = private unnamed_addr constant [6 x i8] c"entry\00", align 1
@1 = private unnamed_addr constant [11 x i8] c"while.body\00", align 1
@2 = private unnamed_addr constant [8 x i8] c"if.then\00", align 1
@3 = private unnamed_addr constant [8 x i8] c"if.else\00", align 1
@4 = private unnamed_addr constant [10 x i8] c"if.then10\00", align 1
@5 = private unnamed_addr constant [10 x i8] c"if.else12\00", align 1
@6 = private unnamed_addr constant [9 x i8] c"if.end15\00", align 1
@7 = private unnamed_addr constant [13 x i8] c"while.body.1\00", align 1
@8 = private unnamed_addr constant [10 x i8] c"if.else.1\00", align 1
@9 = private unnamed_addr constant [12 x i8] c"if.else12.1\00", align 1
@10 = private unnamed_addr constant [12 x i8] c"if.then10.1\00", align 1
@11 = private unnamed_addr constant [10 x i8] c"if.then.1\00", align 1
@12 = private unnamed_addr constant [11 x i8] c"if.end15.1\00", align 1
@13 = private unnamed_addr constant [13 x i8] c"while.body.2\00", align 1
@14 = private unnamed_addr constant [10 x i8] c"if.else.2\00", align 1
@15 = private unnamed_addr constant [12 x i8] c"if.else12.2\00", align 1
@16 = private unnamed_addr constant [12 x i8] c"if.then10.2\00", align 1
@17 = private unnamed_addr constant [10 x i8] c"if.then.2\00", align 1
@18 = private unnamed_addr constant [11 x i8] c"if.end15.2\00", align 1
@19 = private unnamed_addr constant [13 x i8] c"while.body.3\00", align 1
@20 = private unnamed_addr constant [10 x i8] c"if.else.3\00", align 1
@21 = private unnamed_addr constant [12 x i8] c"if.else12.3\00", align 1
@22 = private unnamed_addr constant [12 x i8] c"if.then10.3\00", align 1
@23 = private unnamed_addr constant [10 x i8] c"if.then.3\00", align 1
@24 = private unnamed_addr constant [11 x i8] c"if.end15.3\00", align 1
@25 = private unnamed_addr constant [10 x i8] c"while.end\00", align 1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @sfe_main(ptr noundef readonly captures(none) %arr1, ptr noundef readonly captures(none) %arr2, i32 noundef %m, i32 noundef %n) local_unnamed_addr #0 {
entry:
  call void @trace_bb(ptr @0)
  %cmp27 = icmp sgt i32 %m, 0
  %cmp128 = icmp sgt i32 %n, 0
  %0 = and i1 %cmp27, %cmp128
  br i1 %0, label %while.body, label %while.end

while.body:                                       ; preds = %if.end15.3, %entry
  %total.031 = phi i32 [ %total.1.3, %if.end15.3 ], [ 0, %entry ]
  %j.030 = phi i32 [ %j.1.3, %if.end15.3 ], [ 0, %entry ]
  %i.029 = phi i32 [ %i.1.3, %if.end15.3 ], [ 0, %entry ]
  call void @trace_bb(ptr @1)
  %idxprom = sext i32 %i.029 to i64
  %arrayidx = getelementptr inbounds i32, ptr %arr1, i64 %idxprom
  %1 = load i32, ptr %arrayidx, align 4, !tbaa !5
  %idxprom2 = sext i32 %j.030 to i64
  %arrayidx3 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2
  %2 = load i32, ptr %arrayidx3, align 4, !tbaa !5
  %cmp4 = icmp slt i32 %1, %2
  br i1 %cmp4, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  call void @trace_bb(ptr @2)
  %inc = add nsw i32 %i.029, 1
  br label %if.end15

if.else:                                          ; preds = %while.body
  call void @trace_bb(ptr @3)
  %cmp9 = icmp slt i32 %2, %1
  br i1 %cmp9, label %if.then10, label %if.else12

if.then10:                                        ; preds = %if.else
  call void @trace_bb(ptr @4)
  %inc11 = add nsw i32 %j.030, 1
  br label %if.end15

if.else12:                                        ; preds = %if.else
  call void @trace_bb(ptr @5)
  %inc13 = add nsw i32 %i.029, 1
  %inc14 = add nsw i32 %total.031, 1
  br label %if.end15

if.end15:                                         ; preds = %if.else12, %if.then10, %if.then
  %i.1 = phi i32 [ %inc, %if.then ], [ %i.029, %if.then10 ], [ %inc13, %if.else12 ]
  %j.1 = phi i32 [ %j.030, %if.then ], [ %inc11, %if.then10 ], [ %j.030, %if.else12 ]
  %total.1 = phi i32 [ %total.031, %if.then ], [ %total.031, %if.then10 ], [ %inc14, %if.else12 ]
  call void @trace_bb(ptr @6)
  %cmp = icmp slt i32 %i.1, %m
  %cmp1 = icmp slt i32 %j.1, %n
  %3 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %3, label %while.body.1, label %while.end, !llvm.loop !9

while.body.1:                                     ; preds = %if.end15
  call void @trace_bb(ptr @7)
  %idxprom.1 = sext i32 %i.1 to i64
  %arrayidx.1 = getelementptr inbounds i32, ptr %arr1, i64 %idxprom.1
  %4 = load i32, ptr %arrayidx.1, align 4, !tbaa !5
  %idxprom2.1 = sext i32 %j.1 to i64
  %arrayidx3.1 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2.1
  %5 = load i32, ptr %arrayidx3.1, align 4, !tbaa !5
  %cmp4.1 = icmp slt i32 %4, %5
  br i1 %cmp4.1, label %if.then.1, label %if.else.1

if.else.1:                                        ; preds = %while.body.1
  call void @trace_bb(ptr @8)
  %cmp9.1 = icmp slt i32 %5, %4
  br i1 %cmp9.1, label %if.then10.1, label %if.else12.1

if.else12.1:                                      ; preds = %if.else.1
  call void @trace_bb(ptr @9)
  %inc13.1 = add nsw i32 %i.1, 1
  %inc14.1 = add nsw i32 %total.1, 1
  br label %if.end15.1

if.then10.1:                                      ; preds = %if.else.1
  call void @trace_bb(ptr @10)
  %inc11.1 = add nsw i32 %j.1, 1
  br label %if.end15.1

if.then.1:                                        ; preds = %while.body.1
  call void @trace_bb(ptr @11)
  %inc.1 = add nsw i32 %i.1, 1
  br label %if.end15.1

if.end15.1:                                       ; preds = %if.then.1, %if.then10.1, %if.else12.1
  %i.1.1 = phi i32 [ %inc.1, %if.then.1 ], [ %i.1, %if.then10.1 ], [ %inc13.1, %if.else12.1 ]
  %j.1.1 = phi i32 [ %j.1, %if.then.1 ], [ %inc11.1, %if.then10.1 ], [ %j.1, %if.else12.1 ]
  %total.1.1 = phi i32 [ %total.1, %if.then.1 ], [ %total.1, %if.then10.1 ], [ %inc14.1, %if.else12.1 ]
  call void @trace_bb(ptr @12)
  %cmp.1 = icmp slt i32 %i.1.1, %m
  %cmp1.1 = icmp slt i32 %j.1.1, %n
  %6 = select i1 %cmp.1, i1 %cmp1.1, i1 false
  br i1 %6, label %while.body.2, label %while.end, !llvm.loop !9

while.body.2:                                     ; preds = %if.end15.1
  call void @trace_bb(ptr @13)
  %idxprom.2 = sext i32 %i.1.1 to i64
  %arrayidx.2 = getelementptr inbounds i32, ptr %arr1, i64 %idxprom.2
  %7 = load i32, ptr %arrayidx.2, align 4, !tbaa !5
  %idxprom2.2 = sext i32 %j.1.1 to i64
  %arrayidx3.2 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2.2
  %8 = load i32, ptr %arrayidx3.2, align 4, !tbaa !5
  %cmp4.2 = icmp slt i32 %7, %8
  br i1 %cmp4.2, label %if.then.2, label %if.else.2

if.else.2:                                        ; preds = %while.body.2
  call void @trace_bb(ptr @14)
  %cmp9.2 = icmp slt i32 %8, %7
  br i1 %cmp9.2, label %if.then10.2, label %if.else12.2

if.else12.2:                                      ; preds = %if.else.2
  call void @trace_bb(ptr @15)
  %inc13.2 = add nsw i32 %i.1.1, 1
  %inc14.2 = add nsw i32 %total.1.1, 1
  br label %if.end15.2

if.then10.2:                                      ; preds = %if.else.2
  call void @trace_bb(ptr @16)
  %inc11.2 = add nsw i32 %j.1.1, 1
  br label %if.end15.2

if.then.2:                                        ; preds = %while.body.2
  call void @trace_bb(ptr @17)
  %inc.2 = add nsw i32 %i.1.1, 1
  br label %if.end15.2

if.end15.2:                                       ; preds = %if.then.2, %if.then10.2, %if.else12.2
  %i.1.2 = phi i32 [ %inc.2, %if.then.2 ], [ %i.1.1, %if.then10.2 ], [ %inc13.2, %if.else12.2 ]
  %j.1.2 = phi i32 [ %j.1.1, %if.then.2 ], [ %inc11.2, %if.then10.2 ], [ %j.1.1, %if.else12.2 ]
  %total.1.2 = phi i32 [ %total.1.1, %if.then.2 ], [ %total.1.1, %if.then10.2 ], [ %inc14.2, %if.else12.2 ]
  call void @trace_bb(ptr @18)
  %cmp.2 = icmp slt i32 %i.1.2, %m
  %cmp1.2 = icmp slt i32 %j.1.2, %n
  %9 = select i1 %cmp.2, i1 %cmp1.2, i1 false
  br i1 %9, label %while.body.3, label %while.end, !llvm.loop !9

while.body.3:                                     ; preds = %if.end15.2
  call void @trace_bb(ptr @19)
  %idxprom.3 = sext i32 %i.1.2 to i64
  %arrayidx.3 = getelementptr inbounds i32, ptr %arr1, i64 %idxprom.3
  %10 = load i32, ptr %arrayidx.3, align 4, !tbaa !5
  %idxprom2.3 = sext i32 %j.1.2 to i64
  %arrayidx3.3 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2.3
  %11 = load i32, ptr %arrayidx3.3, align 4, !tbaa !5
  %cmp4.3 = icmp slt i32 %10, %11
  br i1 %cmp4.3, label %if.then.3, label %if.else.3

if.else.3:                                        ; preds = %while.body.3
  call void @trace_bb(ptr @20)
  %cmp9.3 = icmp slt i32 %11, %10
  br i1 %cmp9.3, label %if.then10.3, label %if.else12.3

if.else12.3:                                      ; preds = %if.else.3
  call void @trace_bb(ptr @21)
  %inc13.3 = add nsw i32 %i.1.2, 1
  %inc14.3 = add nsw i32 %total.1.2, 1
  br label %if.end15.3

if.then10.3:                                      ; preds = %if.else.3
  call void @trace_bb(ptr @22)
  %inc11.3 = add nsw i32 %j.1.2, 1
  br label %if.end15.3

if.then.3:                                        ; preds = %while.body.3
  call void @trace_bb(ptr @23)
  %inc.3 = add nsw i32 %i.1.2, 1
  br label %if.end15.3

if.end15.3:                                       ; preds = %if.then.3, %if.then10.3, %if.else12.3
  %i.1.3 = phi i32 [ %inc.3, %if.then.3 ], [ %i.1.2, %if.then10.3 ], [ %inc13.3, %if.else12.3 ]
  %j.1.3 = phi i32 [ %j.1.2, %if.then.3 ], [ %inc11.3, %if.then10.3 ], [ %j.1.2, %if.else12.3 ]
  %total.1.3 = phi i32 [ %total.1.2, %if.then.3 ], [ %total.1.2, %if.then10.3 ], [ %inc14.3, %if.else12.3 ]
  call void @trace_bb(ptr @24)
  %cmp.3 = icmp slt i32 %i.1.3, %m
  %cmp1.3 = icmp slt i32 %j.1.3, %n
  %12 = select i1 %cmp.3, i1 %cmp1.3, i1 false
  br i1 %12, label %while.body, label %while.end, !llvm.loop !12

while.end:                                        ; preds = %if.end15.3, %if.end15.2, %if.end15.1, %if.end15, %entry
  %total.0.lcssa = phi i32 [ 0, %entry ], [ %total.1.3, %if.end15.3 ], [ %total.1.2, %if.end15.2 ], [ %total.1.1, %if.end15.1 ], [ %total.1, %if.end15 ]
  call void @trace_bb(ptr @25)
  ret i32 %total.0.lcssa
}

declare void @trace_bb(ptr)

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 21.0.0git (git@github.com:xavierrouth/llvm-project.git 602d0f3f75adc6cde3ff53a7d79ee7da426abae9)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.count", i32 4}
!12 = distinct !{!12, !10, !13}
!13 = !{!"llvm.loop.unroll.disable"}
