DATA SEGMENT
BUF DB 1,232,123,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,24,22,23,26,25,27,28,29,30,31,32,33,34,35,36,37,38,39,50,40,42,42,43,44,45,46,47,48,49
BTS DW 50 DUP (3030h) ;输出数的ascii码形式存储
BUFCOUNT DW 50 ;buf长度
BTSCOUNT DW 100 ;输出数组长度
LINECOUNT DW 9 ;每行显示的个数
SORTF DW 0 ;排序标志
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
    MOV CX,0 ;计数器，用于记录交换次数进行前后4位的16进制转换
    MOV SI,0 ;计数器，用于记录循环次数
CTH:CMP SI,BUFCOUNT ;比较是否将所有的数字转换
    JE SHOW
    MOV AL,BUF[SI]
    MOV BL,AL ;将数据的前4位和后4位分开保存
    MOV BH,AL 
    MOV CL,4
    SHL BL,CL ;获取后四位
    SHR BH,CL ;获取前四位
    SHR BL,CL
    MOV CX,0
LTH:CMP BL,9 ;转换成字符，9以下加‘0’
    JBE CTASC
    CMP BL,15 ;9以上15以下加‘A’
    JBE CTASCF
MTBTS:MOV CX,0 ;存储到新的数组里
    MOV AX,SI
    ADD SI,AX
    MOV BTS[SI],BX
    SUB SI,AX
    INC SI
    JMP CTH
CTASC:ADD BL,30H 
    XCHG BL,BH ;交换并将两个都转换成对应的ascii
    INC CX
    CMP CX,2
    JE MTBTS
    JMP LTH
CTASCF:ADD BL,37H
    XCHG BL,BH
    INC CX
    CMP CX,2
    JE MTBTS
    JMP LTH
SHOW:MOV SI,0 ;显示逻辑
    MOV CX,0
SHOWLP:CMP SI,BTSCOUNT 
    JE SORT ;如果显示完成，转入排序逻辑
    MOV BX,BTS[SI] ;读取要显示字符
    MOV DL,BH ;调用02功能输出
    MOV AH,02H
    INT 21H
    MOV DL,BL
    MOV AH,02H
    INT 21H
    MOV DL,'H' ;输出16进制标识H
    MOV AH,02H
    INT 21H
    MOV DL,' ' ;空格分隔
    MOV AH,02H
    INT 21H
    CMP CX,LINECOUNT ;检查是否需要换行
    JE OTL
    INC CX
    ADD SI,2
    JMP SHOWLP
OTL:MOV DL,0AH ;输出换行
    MOV AH,02H
    INT 21H
    MOV CX,0 ;清空换行计数器
    ADD SI,2
    JMP SHOWLP
SORT:MOV AX,SORTF ;冒泡排序算法
    CMP AX,1 ;获取排序标识，如果已经排序则直接结束
    JE NEXT
    MOV AX,1 ;设为已排序
    MOV SORTF,AX
    MOV CX,BUFCOUNT
    XOR SI,SI ;清空计数器
    XOR DI,DI 
SL1:MOV AH,BUF[SI] ;冒泡算法的外层循环
SL2:MOV AL,BUF[DI] ;冒泡算法的内层循环
    CMP AH,AL
    JBE SL3
    MOV DH,AH ;交换
    MOV AH,AL
    MOV AL,DH
    MOV BUF[SI],AH
    MOV BUF[DI],AL
SL3:INC DI ;循环继续
    CMP DI,BUFCOUNT
    JB SL2
    INC SI
    MOV DI,SI
    LOOP SL1
    MOV AX,1
    MOV SORTF,AX ;跳转至输出逻辑
    JMP START
NEXT:MOV AX,4C00H ;程序结束
    INT 21H
CODE ENDS
    END START