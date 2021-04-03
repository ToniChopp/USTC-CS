; ModuleID = 'cminus'
source_filename = "gcd.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @gcd(i32, i32) {
entry:
  %2 = alloca i32
  store i32 0, i32* %2
  %3 = alloca i32
  %4 = alloca i32
  store i32 %0, i32* %4
  %5 = alloca i32
  %6 = alloca i32
  store i32 %1, i32* %6
  %7 = load i32, i32* %6
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %trueBB, label %falseBB

trueBB:                                           ; preds = %entry
  %9 = load i32, i32* %4
  store i32 %9, i32* %2
  br label %ret

falseBB:                                          ; preds = %entry
  %10 = load i32, i32* %6
  %11 = load i32, i32* %4
  %12 = load i32, i32* %4
  %13 = load i32, i32* %6
  %14 = sdiv i32 %12, %13
  %15 = load i32, i32* %6
  %16 = mul nsw i32 %14, %15
  %17 = sub nsw i32 %11, %16
  %18 = call i32 @gcd(i32 %10, i32 %17)
  store i32 %18, i32* %2
  br label %ret
                                                  ; No predecessors!

ret:                                              ; preds = %falseBB, %trueBB
  %20 = load i32, i32* %2
  ret i32 %20
}

define i32 @main() {
entry:
  %0 = alloca i32
  store i32 0, i32* %0
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  store i32 72, i32* %1
  store i32 18, i32* %2
  br label %condition

condition:                                        ; preds = %loop, %entry
  %5 = load i32, i32* %1
  %6 = load i32, i32* %2
  %7 = icmp slt i32 %5, %6
  br i1 %7, label %loop, label %done

loop:                                             ; preds = %condition
  %8 = load i32, i32* %2
  %9 = sub nsw i32 %8, 1
  store i32 %9, i32* %2
  br label %condition

done:                                             ; preds = %condition
  %10 = load i32, i32* %1
  %11 = load i32, i32* %2
  %12 = call i32 @gcd(i32 %10, i32 %11)
  store i32 %12, i32* %4
  %13 = load i32, i32* %4
  store i32 %13, i32* %0
  br label %ret

ret:                                              ; preds = %done
  %14 = load i32, i32* %0
  ret i32 %14
}
