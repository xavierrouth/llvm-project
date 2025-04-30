; ModuleID = 'psi.ll'
source_filename = "psi.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define dso_local i32 @sfe_main(ptr noundef readonly captures(none) %arr1, ptr noundef readonly captures(none) %arr2, i32 noundef %m, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp27 = icmp sgt i32 %m, 0
  %cmp128 = icmp sgt i32 %n, 0
  %0 = and i1 %cmp27, %cmp128
  br i1 %0, label %while.body, label %while.end

while.body:                                       ; preds = %entry, %if.end15
  %total.031 = phi i32 [ %total.1, %if.end15 ], [ 0, %entry ]
  %j.030 = phi i32 [ %j.1, %if.end15 ], [ 0, %entry ]
  %i.029 = phi i32 [ %i.1, %if.end15 ], [ 0, %entry ]
  %idxprom = sext i32 %i.029 to i64
  %arrayidx = getelementptr inbounds i32, ptr %arr1, i64 %idxprom
  %1 = load i32, ptr %arrayidx, align 4, !tbaa !5
  %idxprom2 = sext i32 %j.030 to i64
  %arrayidx3 = getelementptr inbounds i32, ptr %arr2, i64 %idxprom2
  %2 = load i32, ptr %arrayidx3, align 4, !tbaa !5
  %cmp4 = icmp slt i32 %1, %2
  br i1 %cmp4, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %inc = add nsw i32 %i.029, 1
  br label %if.end15

if.else:                                          ; preds = %while.body
  %cmp9 = icmp slt i32 %2, %1
  br i1 %cmp9, label %if.then10, label %if.else12

if.then10:                                        ; preds = %if.else
  %inc11 = add nsw i32 %j.030, 1
  br label %if.end15

if.else12:                                        ; preds = %if.else
  %inc13 = add nsw i32 %i.029, 1
  %inc14 = add nsw i32 %total.031, 1
  br label %if.end15

if.end15:                                         ; preds = %if.else12, %if.then10, %if.then
  %i.1 = phi i32 [ %inc, %if.then ], [ %i.029, %if.then10 ], [ %inc13, %if.else12 ]
  %j.1 = phi i32 [ %j.030, %if.then ], [ %inc11, %if.then10 ], [ %j.030, %if.else12 ]
  %total.1 = phi i32 [ %total.031, %if.then ], [ %total.031, %if.then10 ], [ %inc14, %if.else12 ]
  %cmp = icmp slt i32 %i.1, %m
  %cmp1 = icmp slt i32 %j.1, %n
  %3 = select i1 %cmp, i1 %cmp1, i1 false
  br i1 %3, label %while.body, label %while.end, !llvm.loop !9

while.end:                                        ; preds = %if.end15, %entry
  %total.0.lcssa = phi i32 [ 0, %entry ], [ %total.1, %if.end15 ]
  ret i32 %total.0.lcssa
}

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
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
