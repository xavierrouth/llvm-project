# Makefile for compiling and running sfe_main via lli

MAIN = psi-handwritten
WRAPPER_C = wrapper.c
WRAPPER_BC = wrapper.bc
MAIN_BC = main.bc
LINKED_BC = linked.bc
TRACE_BC = ../utils/trace.bc
TRACE_C = ../utils/trace.c
TRACED_LL = $(MAIN)-trace.ll
TRACED_BC = $(MAIN)-trace.bc
LINKED_TRACED_BC = linked_traced.bc

.PHONY: all build run clean

LLVM_BIN_DIR = /workspaces/llvm-project/build/bin

all: build run

$(TRACED_BC): $(TRACED_LL)
	$(LLVM_BIN_DIR)/opt -passes=garble -s $< --debug -o $@

$(TRACE_BC): $(TRACE_C)
	$(LLVM_BIN_DIR)/clang -O0 -emit-llvm -c $< -o $@

garble: 
	$(LLVM_BIN_DIR)/opt -passes=garble psi-handwritten.ll --debug -o $@


build-traced: $(WRAPPER_BC) $(MAIN_BC) $(TRACE_BC)
	$(LLVM_BIN_DIR)/llvm-link $(WRAPPER_BC) $(TRACED_BC) $(TRACE_BC) -o $(LINKED_TRACED_BC)

build: $(WRAPPER_BC) $(MAIN_BC)
	$(LLVM_BIN_DIR)/llvm-link $(WRAPPER_BC) $(MAIN_BC) -o $(LINKED_BC)

$(WRAPPER_BC): $(WRAPPER_C)
	$(LLVM_BIN_DIR)/clang -O0 -emit-llvm -c $< -o $@

$(MAIN_BC): $(MAIN).ll
	$(LLVM_BIN_DIR)/llvm-as $< -o $@

get-main-ll: 
	$(LLVM_BIN_DIR)/clang -O3 -emit-llvm psi.c -S psi.ll

run: $(LINKED_BC)
	$(LLVM_BIN_DIR)/lli $(LINKED_BC)

run-traced: $(LINKED_TRACED_BC)
	$(LLVM_BIN_DIR)/lli $(LINKED_TRACED_BC)

clean:
	rm -f $(WRAPPER_BC) $(MAIN_BC) $(LINKED_BC)
