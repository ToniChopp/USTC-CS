#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>

#include <iostream>
#include <memory>

#ifdef DEBUG  // 用于调试信息,大家可以在编译过程中通过" -DDEBUG"来开启这一选项
#define DEBUG_OUTPUT std::cout << __LINE__ << std::endl;  // 输出行号的简单示例
#else
#define DEBUG_OUTPUT
#endif

using namespace llvm;  
#define CONST(num) \
  ConstantInt::get(context, APInt(32, num))  

int main() {
    LLVMContext context;
    Type *TYPE32 = Type::getInt32Ty(context);
    IRBuilder<> builder(context);
    auto module = new Module("while", context);  


    auto mainFun = Function::Create(FunctionType::get(TYPE32, false),
                                    GlobalValue::LinkageTypes::ExternalLinkage,
                                    "main", module);
    auto bb = BasicBlock::Create(context, "entry", mainFun);
    builder.SetInsertPoint(bb);

    auto aAlloca = builder.CreateAlloca(TYPE32);
    auto iAlloca = builder.CreateAlloca(TYPE32);

    builder.CreateStore(CONST(10), aAlloca);
    builder.CreateStore(CONST(0), iAlloca);

    auto whileBB = BasicBlock::Create(context, "whileBB", mainFun);  // Use whileBB to loop
    auto trueBB = BasicBlock::Create(context, "trueBB", mainFun);
    auto falseBB = BasicBlock::Create(context, "falseBB", mainFun);
    builder.CreateBr(whileBB); 
 
    builder.SetInsertPoint(whileBB);             // Loop
    auto aLoad = builder.CreateLoad(aAlloca);
    auto iLoad = builder.CreateLoad(iAlloca);
    auto icmp = builder.CreateICmpSLT(iLoad, CONST(10)); 
    builder.CreateCondBr(icmp, trueBB, falseBB);

    builder.SetInsertPoint(trueBB);
    auto add1 = builder.CreateNSWAdd(iLoad, CONST(1));
    builder.CreateStore(add1, iAlloca);
    iLoad = builder.CreateLoad(iAlloca);
    auto add2 = builder.CreateNSWAdd(aLoad, iLoad);
    builder.CreateStore(add2, aAlloca);
    builder.CreateBr(whileBB);                 // return to the icmp,to check if continue looping

    builder.SetInsertPoint(falseBB);
    builder.CreateRet(aLoad);

    builder.ClearInsertionPoint();

    module->print(outs(), nullptr);
    delete module;
    return 0;
}