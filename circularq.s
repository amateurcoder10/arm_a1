	PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 

;this program demonstrates the operation of a circular queue of size 10.
;first block of code inserts 10 elements--this illustrates the enqueue operation
;second block deletes 5 elements--this illustrates the dequeue operation
;third block illustrates the wraparound condition by inserting 5 elements
;fourth block illustrates deletion of a few elements after wraparound
;fifth block illustrates deletion till queue is empty
;whenever an element is deleted that address is loaded with FF for ease of debugging

__main  FUNCTION		 
        MOV R2,#0x20000000;start address for the queue
		MOV R3,#0x0A;sample data
		MOV R6,#0x09;enqueue counter
		MOV R9,#0x04;dequeue counter
		MOV R5,#0x28;queue size is for 10 elements so 40 bytes
		MOV R7,#0x20000000;front pointer
		MOV R8,#0x20000000;rear pointer
		MOV R10,#0x04;wraparound  counter
		MOV R11,#0xFF;		
		
insertloop;insert 10 elements
		CMP R6,#0;loop till no of elements equals size
		STR R3,[R8];store contents of r3 into address pointed by rear pointer
		ADD R8,#0x04;increment rear
		ADD R3,#0x01;increment data
		SUBGT R6,R6,#1
		BGT insertloop
		
deleteloop;delete 5 elements
		CMP R9,#0;loop till 5 elements are deleted
		STR R11,[R7];set to ff while deleting
		ADD R7,#0x04;increment front
		SUBGT R9,R9,#1
		BGT deleteloop
		
		MOV R8,R2;reset rear pointer to the base address
insertwrap;wraparound because queue has space in the front
		CMP R10,#0;
		STR R3,[R8];store contents of r3 into address pointed by rear pointer
		ADD R8,#0x04;increment rear
		ADD R3,#0x01;increment data
		SUBGT R10,R10,#1
		BGT insertwrap
		
		MOV R9,#0x04
deletenotempty;delete 5 elements
		CMP R9,#0
		STR R11,[R7];set to ff while deleting
		ADD R7,#0x04;increment front
		SUBGT R9,R9,#1
		BGT deletenotempty
		
		MOV R7,R2;reset rear pointer to the base address
deleteempty;delete till queue is empty
		SUB R9,R8,R7
		CMP R9,#0
		STR R11,[R7];set to ff while deleting
		ADD R7,#0x04;increment front
		BGT deleteempty
		
stop B stop ; stop program
     ENDFUNC
     END