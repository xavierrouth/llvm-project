//===-- InstCount.cpp - Collects the count of all instructions ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass collects the count of all instructions and reports them
//
//===----------------------------------------------------------------------===//

#include "llvm/Transforms/Garble/Garble.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include <emp-ot/emp-ot.h>
#include <emp-tool/emp-tool.h> // For NetIO

// Project Headers
#include "AsParse.h"
#include "Bit.h"
#include "Bit32.h"
#include "Const.h"
#include "Prg.h"
#include "Role.h"
#include "SGCUtils.h"

// EpiGRAM

#include <arithmetic.h>
#include <cpu.h>
#include <epigram.h>
#include <lazypermutation.h>
#include <permute.h>
#include <util.h>

// Standard Headers
#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <fstream>
#include <iostream>
#include <vector>

using namespace llvm;

#define DEBUG_TYPE "garble"

template <Role role> using RegisterFile = std::vector<SGC::Bit32<role>>;

template <Role role> using ValueMap = std::map<Instruction *, SGC::Bit32<role>>;

static cl::opt<int> Runtime("runtime", cl::desc("Predicted number of cycles"),
                            cl::init(100));

struct InternalGarble {
  void GarbleSingleBasicBlock(Module &M, BasicBlock *basic_block,
                              RegisterFile<Role::Garbler> &regfile,
                              ValueMap<Role::Garbler> &value_map,
                              EpiGRAM<Mode::G> &mem);

  void GarbleBasicBlocks(Module &M, std::unordered_set<BBID> live_blocks,
                         RegisterFile<Role::Garbler> &regfile,
                         EpiGRAM<Mode::G> &mem);

  std::pair<std::vector<std::unordered_set<BBID>>, int>
  GenerateCFPath(Function &F, int steps);

  std::map<BasicBlock *, BBID> bbIDs;
  std::map<BBID, BasicBlock *> IDtoBB;

  std::map<BBID, int> mem_access_count;
  std::map<BBID, int> bb_cost;

  int num_bbs;
};

void InternalGarble::GarbleSingleBasicBlock(
    Module &M, BasicBlock *basic_block, RegisterFile<Role::Garbler> &regfile,
    ValueMap<Role::Garbler> &value_map, EpiGRAM<Mode::G> &mem) {

  for (Instruction &I : *basic_block) {

    if (I.getNumOperands() != 2) {
      break;
    }

    std::vector<SGC::Bit32<Role::Garbler>> garbled_ops;

    for (unsigned i = 0; i < 2; i++) {
      Value *op = I.getOperand(i);

      SGC::Bit32<Role::Garbler> garbled_op;

      if (isa<ConstantInt>(op)) {
        int imm_value = (cast<ConstantInt>(op)->getValue()).getZExtValue();
        garbled_op = SGC::GbGetImm(imm_value);
      } else if (value_map.contains(dyn_cast<Instruction>(I.getOperand(i)))) {
        garbled_op = value_map[dyn_cast<Instruction>(I.getOperand(i))];
      } else {
        assert(false);
      }

      garbled_ops.push_back(garbled_op);
    }

    switch (I.getOpcode()) {
    case Instruction::Add: {
      SGC::Bit32<Role::Garbler> garbled_result =
          garbled_ops[0] + garbled_ops[1];
      value_map[&I] = garbled_result;
      break;
    }
    default:
      break;
      // case Instruction::Load:
    }
  }
}

void InternalGarble::GarbleBasicBlocks(Module &M,
                                       std::unordered_set<BBID> live_blocks,
                                       RegisterFile<Role::Garbler> &regfile,
                                       EpiGRAM<Mode::G> &mem) {

  if (live_blocks.size() == 1) {
    // Don't do stacking
    ValueMap<Role::Garbler> value_map;

    BBID id = *live_blocks.begin();
    BasicBlock *bb = this->IDtoBB[id];
    this->GarbleSingleBasicBlock(M, bb, regfile, value_map, mem);
  }

  return;
}

unsigned countSmallLoads(llvm::BasicBlock &BB, const llvm::DataLayout &DL) {
  unsigned count = 0;
  for (llvm::Instruction &I : BB) {
    if (auto *LI = llvm::dyn_cast<llvm::LoadInst>(&I)) {
      llvm::Type *loadedType = LI->getType();
      uint64_t typeSizeInBits = DL.getTypeSizeInBits(loadedType);
      if (typeSizeInBits <= 32) {
        count++;
      }
    }
  }
  return count;
}

// (Set of possible live basic blocks at each time steps, maximum number of
// memory accesses)
std::pair<std::vector<std::unordered_set<BBID>>, int>
InternalGarble::GenerateCFPath(Function &F, int steps) {

  std::vector<std::unordered_set<BBID>> out;

  out.resize(steps);

  uint32_t sum_access_cnt = 0;

  int num_bbs = this->bbIDs.size();
  bool live_blocks[this->num_bbs];
  memset(live_blocks, 0, sizeof(live_blocks));

  BasicBlock *entry_block = &F.getEntryBlock();
  int entry_id = this->bbIDs[entry_block];

  live_blocks[entry_id] = true;

  // This is horrible in so many ways.

  for (int i = 0; i < steps; i++) {
    out[i].clear();
    bool next_live_blocks[num_bbs];
    int max_access_cnt = 0;

    memset(next_live_blocks, 0, sizeof(next_live_blocks));

    // Loop over basic block that we are live in

    for (const auto &[bb, id] : this->bbIDs) {
      if (live_blocks[id] == false)
        continue;

      // For BBs / Fragments that are live, add them to this step's live set.
      out[i].insert(id);

      max_access_cnt = std::max(max_access_cnt, this->mem_access_count[id]);

      // Get IDs of successors
      for (BasicBlock *succ : successors(bb)) {
        next_live_blocks[this->bbIDs[succ]] = true;
      }
    }

    sum_access_cnt += max_access_cnt;

    for (int id = 0; id < num_bbs; id++)
      live_blocks[id] = next_live_blocks[id];
  }

  return std::make_pair(out, sum_access_cnt);
}

void InsertTrace(Function &F) {
  Module *M = F.getParent();
  LLVMContext &Ctx = M->getContext();

  // Declare external function: void trace_bb(char*)
  FunctionCallee traceFunc = M->getOrInsertFunction(
      "trace_bb",
      FunctionType::get(Type::getVoidTy(Ctx),
                        {PointerType::get(Type::getInt8Ty(Ctx), 0)}, false));

  for (BasicBlock &BB : F) {
    IRBuilder<> builder(&*BB.getFirstInsertionPt());
    Value *msg = builder.CreateGlobalStringPtr(BB.getName());
    builder.CreateCall(traceFunc, msg);
  }
}

// Number of and gates
int getInstructionCost(Instruction *I) {
  switch (I->getOpcode()) {
  case Instruction::Or:
  case Instruction::Xor:
  case Instruction::ZExt:
    return 0;
  case Instruction::Add:
  case Instruction::Sub:
  case Instruction::And:
    return 32;
  case Instruction::GetElementPtr:
    return 32;
  case Instruction::SExt:
    return 0;
  case Instruction::Mul:
    return 64;
  case Instruction::UDiv:
  case Instruction::SDiv:
    return 128;
  case Instruction::ICmp:
    return 32;
  case Instruction::Load:
  case Instruction::Store:
    return 0;
  case Instruction::Select:
    return 32;
  case Instruction::Shl:
  case Instruction::LShr:
  case Instruction::AShr:
    return 0;
  case Instruction::Br:
  case Instruction::Ret:
  case Instruction::PHI:
  case Instruction::Call:
    return 0; // No combinational logic
  default: {
    LLVM_DEBUG(dbgs() << "Undefined instruction cost " << I->getOpcodeName()
                      << "\n");
    return 0;
  }
  }
}

int getBasicBlockCost(BasicBlock *BB) {
  int cost = 0;
  for (auto &I : *BB)
    cost += getInstructionCost(&I);
  return cost;
}

PreservedAnalyses GarblePass::run(Module &M, ModuleAnalysisManager &AM) {

  LLVM_DEBUG(dbgs() << "GARBLE: running on function " << M.getName() << "\n");

  Config cfg{256, 256, 64};
  Label zero_label;
  EPCCRH key(zero_label);

  uint32_t max_acc_cnt = 256;

  // Garbler:
  set_delta(key);

  SGC::delta = epdelta();
  SGC::material_id = 0;
  SGC::buffer_idx = 0;

  // Set SGC delta todelta
  // Set material_id, buffer_idx = 0.

  // ======= INITIALIZE GRAM ==========
  std::ifstream fin;

  int bincnt, aincnt, pincnt;
  fin.open("/workspaces/llvm-project/GAR/testinginputs/psi/64/alice.in");

  fin >> bincnt >> aincnt >> pincnt;
  int init_cnt = bincnt + aincnt + pincnt;

  // init_cnt = 256;

  initialize<Mode::S>(key);
  auto arr_s = EpiGRAM<Mode::S>::make(SGC::mem_w, SGC::mem_n);
  const auto ix_s = constant_nat<Mode::S>(log2(SGC::mem_n), 0);
  const auto val_s = constant_nat<Mode::S>(SGC::mem_w, 0);
  for (int i = 0; i < init_cnt; i++)
    arr_s.write(ix_s, val_s);

  // Generate Mode::S Data (necessary!)
  // last arguments is the access #
  SGC::PrepareAccess(arr_s, SGC::mem_w, SGC::mem_n, max_acc_cnt);

  std::cout << scost << std::endl;

  initialize<Mode::G>(key);
  auto arr_g = EpiGRAM<Mode::G>::make(SGC::mem_w, SGC::mem_n);

  for (int i = 0; i < bincnt; i++) {
    std::size_t ix;
    fin >> ix;
    auto val = SGC::Bit32<Role::Garbler>(SGC::EVALUATOR);
    const auto ix_g = constant_nat<Mode::G>(log2(SGC::mem_n), ix % SGC::mem_n);
    std::vector<Garbled::Bit<Mode::G>> val_g(SGC::mem_w);
    for (int j = 0; j < SGC::mem_w; j++)
      val_g[j] = Garbled::Bit<Mode::G>(Label(val.bits[j].wire));
    arr_g.write(ix_g, val_g);
  }

  for (int i = 0; i < aincnt; i++) {
    std::size_t ix;
    std::size_t _val;
    fin >> ix >> _val;
    auto val = SGC::Bit32<Role::Garbler>(SGC::GARBLER, _val);
    const auto ix_g = constant_nat<Mode::G>(log2(SGC::mem_n), ix % SGC::mem_n);
    std::vector<Garbled::Bit<Mode::G>> val_g(SGC::mem_w);
    for (int j = 0; j < SGC::mem_w; j++)
      val_g[j] = Garbled::Bit<Mode::G>(Label(val.bits[j].wire));
    arr_g.write(ix_g, val_g);
  }

  for (int i = 0; i < pincnt; i++) {
    std::size_t ix;
    std::size_t val;
    fin >> ix >> val;
    const auto ix_g = constant_nat<Mode::G>(log2(SGC::mem_n), ix % SGC::mem_n);
    const auto val_g = constant_nat<Mode::G>(SGC::mem_w, val);
    arr_g.write(ix_g, val_g);
  }

  fin.close();

  // ======= Done Initialize GRAM ==========

  // GARBLE THE FRAGMENTS
  int register_file_size = 12;

  RegisterFile<Role::Garbler> regfile(register_file_size);

  InternalGarble garble_ctx;

  // Compute Basic Block Paths
  for (llvm::Function &F : M) {
    for (llvm::BasicBlock &BB : F) {
      garble_ctx.bbIDs[&BB] = garble_ctx.num_bbs;

      garble_ctx.IDtoBB[garble_ctx.num_bbs] = &BB;
      LLVM_DEBUG(dbgs() << "Mapping BB" << BB.getName() << "\tTO: \t"
                        << garble_ctx.num_bbs << "\n");
      garble_ctx.num_bbs++;
    }
  }

  const llvm::DataLayout &DL = M.getDataLayout();

  // Get memory access per block
  for (const auto &[bb, id] : garble_ctx.bbIDs) {
    unsigned count = countSmallLoads(*bb, DL);
    garble_ctx.mem_access_count[id] = count;
    int cost = getBasicBlockCost(bb);
    garble_ctx.bb_cost[id] = cost;

    LLVM_DEBUG(dbgs() << bb->getName() << " costs " << cost << "\n");
  }

  Function *F;

  for (llvm::Function &_F : M) {
    F = &_F;
    break;
  }

  // Annotate function runtime trace information.
  for (llvm::Function &F : M) {
    InsertTrace(F);
  }

  int runtime = Runtime;

  auto [bb_path, max_memory_accesses] = garble_ctx.GenerateCFPath(*F, runtime);

  int predicted_fragments = 0;

  int total_cost = 0;

  for (int i = 0; i < runtime; i++) {
    // LLVM_DEBUG(dbgs() << "Live blocks @ time:" << i << "\n");
    int max_cost = 0;

    for (auto &item : bb_path[i]) {
      BasicBlock *bb = garble_ctx.IDtoBB[item];
      if (max_cost < garble_ctx.bb_cost[item]) {
        max_cost = garble_ctx.bb_cost[item];
      }
      // LLVM_DEBUG(dbgs() << bb->getName() << " ");
    }
    total_cost += max_cost;
    // LLVM_DEBUG(dbgs() << "\n");

    predicted_fragments += bb_path[i].size();
    // garble_ctx.GarbleBasicBlocks(M, bb_path[i], regfile, arr_g);
  }

  LLVM_DEBUG(dbgs() << "Predicted fragments:\t" << predicted_fragments << "\n");
  LLVM_DEBUG(dbgs() << "Predicted Cost:\t" << total_cost << "\n");

  LLVM_DEBUG(dbgs() << "Max Mem Accesses:\t" << max_memory_accesses << "\n");

  return PreservedAnalyses::all();
}
