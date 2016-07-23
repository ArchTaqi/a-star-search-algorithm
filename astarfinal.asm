INPUT MACRO
 MOV AH,01
INT 21H
;SUB AL,30H
;SAL AL,CL
;MOV CH,AL
;MOV AH,01
;INT 21H
;SUB AL,30H
;OR CH,AL     
ENDM 

INPUT1 MACRO var1
MOV DL,var1
ADD Dl,48D
MOV AH,02H
int 21h    
ENDM    

.MODEL SMALL
.DATA     
; Prompt Messages
M3      DB 10, 13, '$'
Msg1 db 0DH,0AH,'How Many Nodes Do You Want in the Graph ... :  $'  
Msg2 db 0DH,0AH,'So The Nodes For The Graphs Are ... :  $'    
Prompt1 db 0DH,0AH,'Now Input the Cost of Each Adjacent ... :  $' 
Prompt2 db ' : $ '   
Prompt3 db 'The Shortest Path Through The Nodes are  : $ '  
n db 0  
Msg3 db 0DH,0AH,'Enter The Cost of G For ... $'
Msg4 db '....To....$'
Msg5 db 0DH,0AH,'Enter the Cost of H For ... $'

;Arrays
NodArr db 20 dup (?)
AdjArr db 100 dup (?)
Address db 50 dup (?)  
GARR db 100 dup (?)
HARR db 100 dup (?)  
temparr db 100 dup (?)
   PATH db 10 dup (?)
    tempArr1 db 100 dup (?)
   
;Variables
   temp db  ?
   temp1 db ? 
   temp2 db ?
   temp3 db ?
   temp4 db ? 
   temp4a db ?
   temp5 db ?
   temp6 db ?
   temp7 db ?
   temp8 db ?
   temp9 db ?
   temp10 db ?
   temp11 db ?
   temp12 db ?
   
   temp20 db ?
   temp21 db ?
   temp22 db ?
   temp23 db ?
   index db ? 
   index2 db ?
   value1 db ?
   value2 db ?
   value3 db ?
   result db ?
   result2 db ?
    temp50 db ?
   

   T1 db ?
   T2 db ?
   T3 db ?
   T4 db ?
   T5 db ?
   T6 db ? 
   count db ? 
   Gvalue db ?
   Hvalue db ?
        
   

.CODE
MAIN PROC  FAR
MOV AX,@DATA
MOV DS,AX 
;MOV BX,OFFSET Address
MOV AX,0

; Input Number of Nodes

LEA DX,Msg1
MOV AH,09H
INT 21H

MOV AH,01H
INT 21H   
SUB AL,30H   ; when we put some data into register it is converted into ascii binary , wo tell the compiler the exact ascii of the decimal entered.
MOV n,AL  
MOV DL,n
add dl,48d
MOV AH,02H
INT 21H

; Show The Entred Numbered Of NODES

Call NEWLINE 
 LEA DX,Msg2
MOV AH,09H
INT 21H


;mov bl,n
;add bl,48d     ; to get out the when decimal equalint binary stored is cambacnk to al/bl it is again convertd, so we add 48d into it.
;MOV DL,bl
;MOV AH,02H
;INT 21H    
    



; Process of Creating  of All Nodes  in an array nodes = 1,2,3,4...n

MOv cl,1 
MOV SI, OFFSET NodArr

CHECK:
CMP cl,n
JBE INSERT_NODES
JMP SHOWNODESS
INSERT_NODES:  
mov al,cl 
MOV [SI],al
MOV AL,[SI]
INC SI
INC cl
JMP CHECK
  
  
; Show the List of Nodes
SHOWNODESS:
  
MOV BX,0
MOV CX,0
MOV DX,0
MOV bl,1
LEA SI,NodArr

SHOWNODES:
MOV DL,[SI]  
ADD Dl,48D
MOV AH,02H
INT 21H 
MOV Dl,','
MOV AH,02H
int 21H
INC SI
INC bl
CMP bl,n
JLE SHOWNODES



;Process of Creating Adjacent Nodes

CADJNOD:
SUB AX,AX
MOV CL,1
MOV temp,0
MOV DI, OFFSET AdjArr   
MOV BX, OFFSET Address


CHECKARRAY: 
CMP CL,n
JB ADJACENT
JMP INPUTTING


ADJACENT:
MOV temp1,CL
INC CL       
mov Al,temp
MOV [BX],Al 
mov CH,1

LOOPP:    
mov AL,CL
MOV [DI],AL
INC CL
INC DI
INC CH
INC temp
CMP CL,n
JA UNDER
CMP CH,3
JLE LOOPP
JMP UNDER



UNDER:  
MOV CL,temp1
INC CL   
INC BX
JMP CHECKARRAY


; Process of Inputting the Cost fo G and H For the Each Adjacent
  
INPUTTING:  

LEA DX,Prompt1
MOV AH,09H
INT 21H
  
mov ax,0
mov ah,1
LEA SI,GARR 
LEA DI,HARR


NODELOOP3:
CMP AH,n
JL INPUTTTINGG
JLE CALCULATION

; 


;Msg3 db 0DH,0AH,'Enter The Cost of G For ... $'
;Msg4 db '....To....$'
;Msg5 db 0DH,0AH,'Enter the Cost of H For ... $'
INPUTTTINGG:
mov temp2,AH
inc AH
mov temp3,AH
mov temp4a,1

LOOOOOPPPP:
Call NEWLINE      ; Transfer to the Next Line
call Msg3P        ; Enter Value of G For 
INPUT1 temp2      ; 1
call MSG4P        ; ....to.....
INPUT1 temp3      ; 2,3,4
call Prompt2P      ; ....: 
INPUT             ; Calls a Macro That will Input the Cost of G in double Digit value & the value will save in ch..
sub al,30h
mov temp4,al   ; cost of g

Call NEWLINE
call Msg5P
INPUT1 temp2
call MSG4P
INPUT1 temp3   
call Prompt2P
INPUT       
sub al,30h
mov temp5,al  ; cost of h


mov bl,temp4
mov al,bl
;and al,30h
MOV [SI],al

mov bl,temp5
mov al,bl
;and al,30h 
;and al,0fh
MOV [DI],bl

INC SI
INC DI
INC temp3 
INC temp4a
mov bl,n
CMP temp3,bl
JA  UNDERRR
CMP temp4a,3
JLE LOOOOOPPPP
JMP UNDERRR



UNDERRR:

mov ah,temp2
mov al,ah
and al,0fh
mov ah,al
inc ah
JMP  NODELOOP3


; Process of Calculatin of Shortes Path

CALCULATION:
LEA BX,PATH
MOV [BX],1  
MOV count,0  
mov al,count
MOV AH,1

CALCULATE1:
INC count
mov al,count
mov al,n
CMP AH,n  
JAE ANSWER
JB CALCULATE2


CALCULATE2:
MOV T1,AH 
mov al,T1
INC T1   
mov al,T1
MOV T2,AH
mov al,T2
INC T2   
mov al,T2

; Get The Index From the Address Array
LEA BX,Address
MOV T3,AH
mov al,t3
DEC T3   
mov al,T3
LEA SI,T3 
  mov al,0
CMP1:
     cmp al,T3
     JE CMP1Close
     INC BX
     INC al
     jmp CMP1
     
CMP1Close:     
MOV AL,[BX]
;sub al,30h
MOV index,AL

; Get the Adjacent Array index With reference of index
LEA BX,AdjArr 
;LEA SI,index  
mov al,0
CMP2:
cmp al,index
JE CMP2Close
INC al
INC BX
JMP CMP2


CMP2Close:
MOV AL,[BX]
MOV T4,AL
MOV T5,AL
MOV T6,1


LOOP1:
LEA BX,GARR
mov cl,0
CMP3:
cmp cl,index
JE CMP3Close
INC cl
INC BX
JMP CMP3
CMP3Close:
MOV AL,[BX] 
MOV Gvalue,AL

LEA BX,HARR
mov cl,0
CMP4:
cmp cl,index
JE CMP4Close
INC cl
INC BX
JMP CMP4
CMP4Close:
MOV AL,[BX] 
MOV Hvalue,AL 
mov AL,Gvalue
Add AL,Hvalue
DAA

MOV result,AL



LEA BX,temparr
mov cl,0
CMP5: 
CMP cl,T4
JE CMP5close
INC CL
INC BX
JMP CMP5

CMP5close:
MOV AL,result
MOV [BX],AL
INC T4
INC T6
INC index
mov al,n
CMP T4,al
JA UNDER50
CMP T6,3
JA UNDER50
JMP LOOP1



UNDER50: 
MOV AL,T4
mov cl,T5 ; only for checking.....
CMP T5,AL
JAE END50
;LEA SI,T5
LEA BX,temparr
mov cl, 0
CMP6:
cmp cl,T5
JE CMP6Close
INC cl
INC BX
JMP CMP6
CMP6Close:
MOV AL,[BX]
MOV value1,AL
MOV result,AL
INC T5  
MOV AL,T4
CMP T5,AL
JAE END50
LEA BX,temparr
mov cl,0
CMP7: 
mov al,T5
cmp cl,T5
JAE  CMP7Close
INC CL
INC BX
JMP CMP7
CMP7Close:
MOV AL,[BX]
MOV value2,AL  
MOV AL,value2
CMp value1,AL
JL T25
JG T26
JE T27

T25: 
MOV AL,value1
MOV result2,AL
dec T5
MOV AL,T5
MOv index2,AL
INC T5
JMP UNDER51

T26:  
MOV AL,value2
MOV result2,AL 
MOV AL,T5
MOV index2,AL
JMp UNDER51

T27: 
MOV AL,value1
MOV result2,AL
DEC T5    
MOV AL,T5
MOV index2,AL
INC T5
JMP UNDER51


UNDER51:
INC T5
MOV AL,T5  
MOV AL,T4
CMP T5,AL
JAE END50
LEA BX,temparr
mov cl,0
CMP8:
cmp cl,T5
JAE CMP8Close
INC CL
INC BX
JMP CMP8
CMP8Close:
MOV AL,[Bx]
MOV value3,AL   
MOV AL,value3
CMP result2,AL
JL T28
JG T29
jE T30


T28:
MOV AL,result2
mov result,al
dec T5   
MOV AL,T5
MOV index2,AL
JMP END50

T29:
MOV Al,value3
MOV result2,Al 
MOV AL,T5
MOV index2,AL
JMP END50

T30:
MOV AL,result2
mov result,al
dec T5   
MOV AL,T5
MOV index2,AL
JMP END50


END50:
LEA BX,PATH
mov al,count 
MOV AL,result2  
MOV AL,index2
mov cl,0
CMP9:
cmp cl,count
JAE CMP9Close
INC CL
INC BX
JMP CMP9
CMP9Close:
MOV [BX],AL
MOV AH,index2
JMP CALCULATE1



         
ANSWER:   
 MOV AH,  09H           ; Carrige return and next line
MOV DX,  OFFSET M3
INT 21H 

LEA DX,Prompt3
MOV AH,09H
INT 21H
mov al,count
LEA BX,PATH
MOV cl,0

CHECK125:
MOV DL,[BX]
add dl,30h
MOV AH,02H
INT 21H 
MOV DL,','
MOV AH,02H
INT 21H
INC BX  
INC cl
CMP cl,count
JLE CHECK125 
JMP FINISH125
     
ENDP MAIN 


NEWLINE PROC NEAR
       MOV AH,  09H           ; Carrige return and next line
       MOV DX,  OFFSET M3
       INT 21H 
       ret
NEWLINE ENDP 

Msg3P PROC NEAR 
      LEA DX,Msg3
      MOV AH,09H  
      INT 21H
      ret
Msg3P ENDP  

MSG4P PROC NEAR
     LEA dx,MSG4
     mov ah,09h
     int 21h    
    
ret 
MSG4P ENDP

Msg5P PROC NEAR
     LEA DX,Msg5
     MOV AH,09H  
     INT 21H 
ret       
Msg5P ENDP 

Prompt2P PROC NEAR
         LEA dx,Prompt2
         mov ah,09h
         int 21h       
ret
Prompt2P ENDP
        
FINISH125:         
END MAIN
