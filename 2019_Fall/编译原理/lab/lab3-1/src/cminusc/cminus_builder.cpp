#include "cminus_builder.hpp"
#include <iostream>
#define CONST(num) \
  llvm::ConstantInt::get(context, llvm::APInt(32, num))  //得到常数值的表示,方便后面多次用到
llvm::BasicBlock* ret;
llvm::Value* expression_value;
llvm::Function* Fun;
std::vector<std::shared_ptr<syntax_param>> upper_params;
#define TypeInt  llvm::Type::getInt32Ty(context)
#define TypeVoid  llvm::Type::getVoidTy(context)
#define TypePtr  llvm::Type::getInt32Ty(context)->getPointerTo()
// You can define global variables here
// to store state

void CminusBuilder::visit(syntax_program &node) {
    for (auto decl: node.declarations){
        decl->accept(*this);
    }
}

void CminusBuilder::visit(syntax_num &node) 
{
    expression_value = CONST(node.value);
}

void CminusBuilder::visit(syntax_var_declaration &node) 
{
    if(scope.in_global())
    {
        if(node.num==nullptr)
        {
            auto TYPE32=llvm::Type::getInt32Ty(context);
            auto address = new llvm::GlobalVariable(*module.get(),TYPE32, 0, llvm::GlobalValue::CommonLinkage, CONST(0));
            scope.push(node.id,address);
        }
        else
        {
            auto TYPE32=llvm::Type::getInt32Ty(context);
            auto TypeArray=llvm::ArrayType::get(TYPE32,node.num->value);
            auto elementptr = new llvm::GlobalVariable(*module.get(),TYPE32, 0, llvm::GlobalValue::CommonLinkage, CONST(0));
            scope.push(node.id,elementptr);
        }
       
    }
    else
    {
        if(node.num==nullptr)
        {
            auto TYPE32=llvm::Type::getInt32Ty(context);
            auto address = builder.CreateAlloca(TYPE32);
            scope.push(node.id,address);
        }
        else
        {
            auto TYPE32=llvm::Type::getInt32Ty(context);
            auto elementptr = builder.CreateAlloca(TYPE32, CONST(node.num->value));
            scope.push(node.id,elementptr);
        }
        
    }
    
}

void CminusBuilder::visit(syntax_fun_declaration &node) 
{
    upper_params=node.params;
    std::vector<llvm::Type *> param_type;
    for(auto param:node.params)
    {
        if(param->isarray==0)
        {
            param_type.push_back(llvm::Type::getInt32Ty(context));
        }
        else
        {
            param_type.push_back(llvm::Type::getInt32Ty(context)->getPointerTo());
        }
    }
    llvm::Type *Ty;
    if(node.type==0)
    {
        Ty=TypeInt;
    }
    else
    {
        Ty=TypeVoid;
    }
    Fun = llvm::Function::Create(llvm::FunctionType::get(Ty, param_type, false),
                                 llvm::GlobalValue::LinkageTypes::ExternalLinkage,
                                 node.id, module.get());
    auto bb =llvm::BasicBlock::Create(context, "entry", Fun);
    builder.SetInsertPoint(bb);
    scope.push(node.id,Fun);

    node.compound_stmt->accept(*this);
    

}

void CminusBuilder::visit(syntax_param &node) {
    
}

void CminusBuilder::visit(syntax_compound_stmt &node) 
{
    ret = llvm::BasicBlock::Create(context, "Ret");
    
    if(scope.in_global()==0)
    {
        scope.enter();
        for (auto decl: node.local_declarations) 
        {
            decl->accept(*this);
        }

        for (auto stmt: node.statement_list) 
        {
            stmt->accept(*this);
        }
        scope.exit();
    }
    else
    {
        scope.enter();
        auto ret_addr = builder.CreateAlloca(TypeInt);
        builder.CreateStore(CONST(0),ret_addr);
        scope.push("ret_addr",ret_addr);
        auto arg = Fun->arg_begin();
        for (auto param:upper_params)
        {
            llvm::AllocaInst* address;
            address = builder.CreateAlloca(TypeInt);
            if(arg->getType()==TypeInt)
            {
                address = builder.CreateAlloca(TypeInt);
                builder.CreateStore(arg,address);
                scope.push(param->id,address);
            }
            else
            {
                address = builder.CreateAlloca(TypePtr);
                builder.CreateStore(arg,address);
                auto pointed_addr = builder.CreateLoad(address);
                scope.push(param->id,pointed_addr);
            }
            arg+=1;
        }
        for (auto decl: node.local_declarations) 
        {
            decl->accept(*this);
        }

        for (auto stmt: node.statement_list) 
        {
            stmt->accept(*this);
        }
        ret->insertInto(Fun);
        builder.SetInsertPoint(ret);
        auto ReturnAddr = builder.CreateLoad(scope.find("ret_addr"));
        if(Fun->getReturnType()==TypeInt)
        {
            builder.CreateRet(ReturnAddr);
        }
        else
        {
            builder.CreateRetVoid();
        }
        scope.exit();

    }
    
    
    
}

void CminusBuilder::visit(syntax_expresion_stmt &node) 
{
    node.expression->accept(*this);
}


void CminusBuilder::visit(syntax_selection_stmt &node) {
  node.expression->accept(*this);
  auto trueBB = llvm::BasicBlock::Create(this->context, "trueBB", Fun);    // true分支
  auto falseBB = llvm::BasicBlock::Create(this->context, "falseBB", Fun);  // false分支
  auto ifendBB = llvm::BasicBlock::Create(
    this->context, "", Fun);
  auto br = builder.CreateCondBr(expression_value, trueBB, falseBB);  // 条件BR
  builder.SetInsertPoint(trueBB);
  node.if_statement->accept(*this);
  if (node.else_statement != nullptr){
    if (trueBB->getTerminator() == nullptr) builder.CreateBr(ifendBB);
    builder.SetInsertPoint(falseBB);
    node.else_statement->accept(*this);
    if (falseBB->getTerminator() == nullptr){
      builder.CreateBr(ifendBB);
      builder.SetInsertPoint(ifendBB);
    }
  }
  else{
    builder.CreateBr(falseBB);
    builder.SetInsertPoint(falseBB);
  }
}

void CminusBuilder::visit(syntax_iteration_stmt &node) 
{
    auto condition = llvm::BasicBlock::Create(context, "condition", Fun);
    auto loop = llvm::BasicBlock::Create(context, "loop", Fun);
    auto done = llvm::BasicBlock::Create(context, "done", Fun);
    builder.CreateBr(condition);
    builder.SetInsertPoint(condition);
    node.expression->accept(*this);
    builder.CreateCondBr(expression_value, loop, done);

    builder.SetInsertPoint(loop);
    node.statement->accept(*this);
    builder.CreateBr(condition);
    builder.SetInsertPoint(done);
}

void CminusBuilder::visit(syntax_return_stmt &node) 
{
    if(node.expression==nullptr)
    {
        builder.CreateBr(ret);
    }
    else
    {
        node.expression->accept(*this);
        builder.CreateStore(expression_value, scope.find("ret_addr"));
        builder.CreateBr(ret);
    }
    
        

}

void CminusBuilder::visit(syntax_var &node) 
{

    auto addr =(llvm::AllocaInst *)scope.find(node.id);
    if(node.expression == nullptr && !addr->isArrayAllocation())
    {
        expression_value = builder.CreateLoad(scope.find(node.id));
    }
    else
    {
        if(node.expression != nullptr)
        {
            node.expression->accept(*this);
        }
        else expression_value =CONST(0);
        expression_value = builder.CreateGEP(scope.find(node.id),expression_value);
        expression_value = builder.CreateLoad(expression_value);

    }
    
}

void CminusBuilder::visit(syntax_assign_expression &node) 
{
    if(node.var->expression ==nullptr)
    {
        node.expression->accept(*this);
        builder.CreateStore(expression_value, scope.find(node.var->id));
    }
    else
    {
        node.var->expression->accept(*this);
        auto elementptr = builder.CreateGEP(scope.find(node.var->id),expression_value);
        node.expression->accept(*this);
        builder.CreateStore(expression_value, elementptr);
    }
    
    


}

void CminusBuilder::visit(syntax_simple_expression &node) 
{

    if (node.additive_expression_r != nullptr)
    {
        node.additive_expression_l->accept(*this);
        auto additive_value_l = expression_value;
        node.additive_expression_r->accept(*this);
        auto additive_value_r = expression_value;
        if (node.op == 0) expression_value = builder.CreateICmpSLE(additive_value_l,additive_value_r);
        else if(node.op == 1) expression_value = builder.CreateICmpSLT(additive_value_l,additive_value_r);
        else if(node.op == 2) expression_value = builder.CreateICmpSGT(additive_value_l,additive_value_r);
        else if(node.op == 3) expression_value = builder.CreateICmpSGE(additive_value_l,additive_value_r);
        else if(node.op == 4) expression_value = builder.CreateICmpEQ(additive_value_l,additive_value_r);
        else expression_value = builder.CreateICmpNE(additive_value_l,additive_value_r);
    }
    else
    {
        node.additive_expression_l->accept(*this);
    }
    
}

void CminusBuilder::visit(syntax_additive_expression &node) 
{
    if (node.additive_expression != nullptr)
    {
        node.additive_expression->accept(*this);
        auto additive_value = expression_value;
        node.term->accept(*this);
        if (node.op == 1) expression_value = builder.CreateNSWSub(additive_value, expression_value);
        else expression_value = builder.CreateNSWAdd(additive_value, expression_value);
    }
    else
    {
       node.term->accept(*this);
    }
    
}

void CminusBuilder::visit(syntax_term &node) 
{
    if (node.term != nullptr)
    {
        node.term->accept(*this);
        auto term_value = expression_value;
        node.factor->accept(*this);
        if (node.op == 1) expression_value = builder.CreateSDiv(term_value, expression_value);
        else expression_value = builder.CreateNSWMul(term_value, expression_value);
    }
    else
    {
        node.factor->accept(*this);
    }
    
}

void CminusBuilder::visit(syntax_call &node) 
{
    std::vector<llvm::Value*> arg_type;
    for (auto arg:node.args)
    {
        arg->accept(*this);
        arg_type.push_back(expression_value);
    }
    expression_value = builder.CreateCall(scope.find(node.id), arg_type);
}
