//===- InstCount.h - Collects the count of all instructions -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass garbles
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_GARBLE_H
#define LLVM_TRANSFORMS_GARBLE_H

#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"

#include <map>
#include <unordered_set>


namespace llvm {

using BBID = int;



struct GarblePass : PassInfoMixin<GarblePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM);

};

} // end namespace llvm

#endif // LLVM_TRANSFORMS_GARBLE_H
