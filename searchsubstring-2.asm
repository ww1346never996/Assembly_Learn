DATA SEGMENT
STR DB 'HELLO WORLD!',00H ;定义的字符串
SUBS DB 'WORLD',00H ;需要查找的子串
FOUND DB 00H
POS DW ?
DATA ENDS
STACK SEGMENT STACK
    DW 200H DUP(?)
STACK ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
    MOV BX,0 ;初始化子串计数器
    MOV SI,0 ;初始化字符串计数器
LP: MOV AL,STR[SI] ;字符串按顺序读取
    MOV AH,SUBS[BX] ;子串按顺序读取
    CMP AH,00H ;如果子串结束，应该继续找到逻辑
    JNE FS ;如果子串未结束，考虑00h作为结尾标识不计入字符串的情况，则应该在主字符串结束时跳转至未找到逻辑
    MOV FOUND,0FFH
    JMP NEXT ;跳转至结束逻辑
FS: CMP AL,00H ;如果字符串结束，跳转至未找到逻辑
    JE FNE
    CMP AH,AL ;比较两个串中的元素，相等则进行下一步判断
    JNE RF
    INC BX
    INC SI
    JMP LP ;返回循环
RF: INC SI ;不相等的时候重置计数器
    SUB SI,BX
    MOV BX,0
    JMP LP
FNE: MOV FOUND,00H
NEXT: SUB SI,BX ;计算子串出现的位置
    MOV POS,SI
    MOV AX,4C00H ;安全退出至操作系统
    INT 21H
CODE ENDS
    END START
    